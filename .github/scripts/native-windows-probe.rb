# frozen_string_literal: true

# Isolate hard native exits so Rake cannot replace the Windows exit code.
require "json"
require "rbconfig"
require "tempfile"
require "timeout"

$stdout.sync = $stderr.sync = true

def event(name, **fields)
  puts JSON.generate(event: name, **fields)
end

if %w[--child --child-file].include?(ARGV.first)
  payload = ARGV.first == "--child-file" ? File.read(ARGV.fetch(1)) : ARGV.fetch(1)
  probe = JSON.parse(payload)
  native_calls = 0
  begin
    event("before_require", probe: probe)
    require "bundler/setup"
    require "plurimath"
    raise "native compatibility extension is required" unless
      Parsanol::Native.available? && Parsanol::Native.respond_to?(:_parse_handle_with_compatibility)

    event("runtime", ruby: RUBY_DESCRIPTION, parsanol: Parsanol::VERSION,
                     gem_root: Gem.loaded_specs["parsanol"]&.full_gem_path,
                     vm_defaults: defined?(RubyVM::DEFAULT_PARAMS) ? RubyVM::DEFAULT_PARAMS : nil,
                     native: $LOADED_FEATURES.grep(/parsanol_native/))
    # An explicit guard makes a recovery/acceptance pass visible and fatal.
    Parsanol::Atoms::Base.prepend(Module.new do
      def run_with_context(*)
        raise "Ruby interpreter fallback forbidden in native runtime probe"
      end
    end)
    trace = Module.new
    %i[_parse_handle _parse_handle_with_compatibility _parse_handle_prefix].each do |entrypoint|
      next unless Parsanol::Native.respond_to?(entrypoint)

      trace.define_method(entrypoint) do |*args|
        native_calls += 1
        event("before_native", entrypoint: entrypoint, input_bytes: args[1].bytesize)
        result = super(*args)
        event("after_native", entrypoint: entrypoint)
        result
      end
    end
    Parsanol::Native.singleton_class.prepend(trace)
    parser = { "html" => Plurimath::Html, "latex" => Plurimath::Latex,
               "unicode" => Plurimath::UnicodeMath }.fetch(probe.fetch("format"))
    event("before_parse", id: probe.fetch("id"), operation: probe.fetch("operation"))
    if probe.fetch("operation") == "raw"
      preprocessing = parser::Parser.new(probe.fetch("input"))
      text = probe.fetch("format") == "html" ? preprocessing.send(:normalized_text) : preprocessing.text
      parser::Parse.new.parse(text, mode: :native)
    else
      Plurimath::Math.parse(probe.fetch("input"), probe.fetch("format").to_sym)
    end
    raise "no native entrypoint executed" if native_calls.zero?
    raise "expected refusal, but parse succeeded" if probe["refusal"] == true

    event("after_parse", outcome: "accepted", native_calls: native_calls)
  rescue Exception => e # Also expose load errors and Ruby-level fatal failures.
    refusal = (defined?(Parsanol::ParseFailed) && e.is_a?(Parsanol::ParseFailed)) ||
      (defined?(Plurimath::Math::ParseError) && e.is_a?(Plurimath::Math::ParseError)) ||
      e.is_a?(JSON::NestingError)
    if refusal
      event("after_parse", outcome: "refused", error: e.class.name,
                           message: e.message, native_calls: native_calls)
      exit 1 if native_calls.zero? || probe["refusal"] == false
    else
      warn JSON.generate(event: "exception", error: e.class.name,
                         message: e.message, backtrace: e.backtrace&.first(12))
      exit 1
    end
  end
  exit 0
end

cases = [
  ["html-table-without-close-entity", "html", "<table><tr><td>&alpha;</td></tr>", true, true],
  ["html-depth-50", "html", "x" * 50, false, false],
  ["html-depth-100", "html", "x" * 100, false, nil],
  ["html-nesting-too-deep", "html", "x" * 101, false, true],
  ["latex-simple", "latex", "x", false, false],
  ["unicode-shared-script", "unicode", "M_1 M_2", false, false],
]
failed = false
crashed_probe = nil
cases.each do |id, format, input, raw_refusal, public_refusal|
  { "raw" => raw_refusal, "public" => public_refusal }.each do |operation, refusal|
    probe = { id: id, format: format, input: input, operation: operation, refusal: refusal }
    event("spawn", probe: probe)
    Tempfile.create("native-probe-out") do |stdout|
      Tempfile.create("native-probe-err") do |stderr|
        pid = Process.spawn(RbConfig.ruby, __FILE__, "--child", JSON.generate(probe),
                            out: stdout.path, err: stderr.path)
        timed_out = false
        status = begin
          Timeout.timeout(60) { Process.wait2(pid).last }
        rescue Timeout::Error
          timed_out = true
          Process.kill("KILL", pid)
          Process.wait2(pid).last
        end
        stdout.rewind
        stderr.rewind
        puts stdout.read
        warn stderr.read
        code = status.exitstatus
        event("process_status", id: id, operation: operation, success: status.success?,
                                exitstatus: code, exitstatus_u32: code && (code & 0xffff_ffff),
                                exitstatus_hex: code && format("0x%08X", code & 0xffff_ffff),
                                termsig: status.termsig, raw_status: status.to_i,
                                status: status.inspect, timed_out: timed_out)
        failed ||= timed_out || !status.success?
        crashed_probe ||= probe if status.termsig == 11
      end
    end
  end
end

if crashed_probe
  candidates = ENV.fetch("PATH", "").split(File::PATH_SEPARATOR)
    .map { |directory| File.join(directory, "gdb.exe") }
  debugger = (candidates + ["C:/mingw64/bin/gdb.exe"]).find { |path| File.file?(path) }
  event("debugger", executable: debugger, probe: crashed_probe)
  if debugger
    Tempfile.create(["native-probe", ".json"]) do |payload|
      payload.write(JSON.generate(crashed_probe))
      payload.flush
      # A command file avoids Windows argument splitting of multiword -ex values.
      Tempfile.create(["native-probe-gdb", ".txt"]) do |commands|
        commands.write("set pagination off\nset debuginfod enabled off\n" \
                       "set print frame-arguments none\nrun\n" \
                       "info registers rsp rbp\nthread apply all bt 80\n")
        commands.flush
        args = [debugger, "--batch", "--quiet", "--command", commands.path, "--args",
                RbConfig.ruby, __FILE__, "--child-file", payload.path]
        pid = Process.spawn(*args)
        begin
          Timeout.timeout(90) { Process.wait(pid) }
        rescue Timeout::Error
          Process.kill("KILL", pid)
          Process.wait(pid)
          event("debugger_timeout")
        end
      end
    end
  end
end
exit(failed ? 1 : 0)
