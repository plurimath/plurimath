# frozen_string_literal: true

# Measures the cost of `require "plurimath"` and of the first conversion
# after it, and prints the result as JSON.
#
# Usage:
#   bundle exec ruby scripts/measure_require.rb [--output FILE]
#     [--samples N] [--engine ox|oga|leptris]
#
#   --output FILE   write the JSON to FILE instead of standard output.
#   --samples N     number of cold child processes to measure (default 5).
#                   Time, allocation and memory figures are the median over
#                   the samples; counts must agree across samples.
#   --engine NAME   XML engine selected at require time through the same
#                   environment variables lib/plurimath.rb reads (default ox).
#
# Each sample is a fresh Ruby process, so every require is cold. Bundler is
# set up before the clock starts (bundle exec loads it through RUBYOPT), so
# the figures cover plurimath and the gems it pulls in, not Bundler itself.
#
# Measured per sample:
#   require    wall time, allocated objects, RSS growth, loaded features
#              (total, plurimath's own lib files, and per gem)
#   first_use  the same figures for Plurimath::Math.parse("x^2", :asciimath)
#              followed by #to_mathml, which loads what require deferred
#   autoload   declared `autoload` statements in lib/ (static scan) and the
#              autoloads still pending after require and after first use
#              (runtime walk of the Plurimath namespace)
#
# The output is deterministic in shape: keys are sorted, lists are sorted and
# no timestamps are recorded. Time and memory values vary between runs; the
# counts do not, unless the code or its dependencies change.
#
# Exit status: 0 on success; 1 when samples disagree on a count; 2 on a usage
# error or a failed child process.

require "json"
require "open3"
require "optparse"
require "rbconfig"
require "etc"

module MeasureRequire
  SCHEMA = "plurimath-perf/require/1"
  ROOT = File.expand_path("..", __dir__)
  LIB = File.join(ROOT, "lib")
  ENGINES = {
    "ox" => {},
    "oga" => { "PLURIMATH_OGA" => "1" },
    "leptris" => { "PLURIMATH_LEPTRIS" => "1" },
  }.freeze

  # Runs inside each cold child process. Prints one JSON line.
  CHILD = <<~'RUBY'
    require "json"

    def rss_kb
      status = File.read("/proc/self/status")
      status[/^VmRSS:\s+(\d+)/, 1].to_i
    rescue SystemCallError
      `ps -o rss= -p #{Process.pid}`.to_i
    end

    # The clock is read after GC when a phase starts and before GC when it
    # ends, so collection triggered by the probe itself is not timed.
    def snapshot(phase)
      clock = Process.clock_gettime(Process::CLOCK_MONOTONIC) if phase == :finish
      GC.start
      clock ||= Process.clock_gettime(Process::CLOCK_MONOTONIC)
      {
        features: $LOADED_FEATURES.dup,
        allocated: GC.stat(:total_allocated_objects),
        rss_kb: rss_kb,
        clock: clock,
      }
    end

    def delta(before, after, lib)
      features = after[:features] - before[:features]
      gems = Hash.new(0)
      own = 0
      other = 0
      features.each do |path|
        if path.start_with?(lib + "/")
          own += 1
        elsif (name = path[%r{/gems/([^/]+?)-\d[^/]*/}, 1] ||
                      path[%r{/bundler/gems/([^/]+?)-[0-9a-f]+/}, 1])
          gems[name] += 1
        else
          other += 1
        end
      end
      {
        wall_ms: ((after[:clock] - before[:clock]) * 1000).round(1),
        allocated_objects: after[:allocated] - before[:allocated],
        rss_growth_kb: after[:rss_kb] - before[:rss_kb],
        loaded_features: features.size,
        plurimath_lib_files: own,
        stdlib_and_other_files: other,
        gem_files: gems.sort.to_h,
      }
    end

    def pending_autoloads(root)
      pending = []
      seen = {}
      queue = [root]
      until queue.empty?
        mod = queue.shift
        next if seen[mod]

        seen[mod] = true
        mod.constants(false).sort.each do |name|
          if mod.autoload?(name, false)
            pending << "#{mod.name}::#{name}"
            next
          end
          value = begin
            mod.const_get(name, false)
          rescue NameError, LoadError
            next
          end
          next unless value.is_a?(Module) && value.name&.start_with?("#{mod.name}::")

          queue << value
        end
      end
      [pending.sort, seen.size]
    end

    lib = ARGV.fetch(0)
    start = snapshot(:start)
    require "plurimath"
    loaded = snapshot(:finish)
    pending_after_require, modules_after_require = pending_autoloads(Plurimath)

    before_use = snapshot(:start)
    formula = Plurimath::Math.parse("x^2", :asciimath)
    formula.to_mathml
    used = snapshot(:finish)
    pending_after_use, modules_after_use = pending_autoloads(Plurimath)

    specs = %w[amath lutaml-model mml omml ox oga leptris parsanol parslet unitsml]
    puts JSON.generate(
      require: delta(start, loaded, lib),
      first_use: delta(before_use, used, lib),
      pending_after_require: pending_after_require,
      modules_after_require: modules_after_require,
      pending_after_use: pending_after_use,
      modules_after_use: modules_after_use,
      xml_engine: Plurimath.xml_engine.to_s,
      plurimath_version: Plurimath::VERSION,
      gems: specs.filter_map { |n| (s = Gem.loaded_specs[n]) && [n, s.version.to_s] }.to_h,
    )
  RUBY

  module_function

  def parse_options(argv)
    options = { samples: 5, engine: "ox", output: nil }
    OptionParser.new do |opts|
      opts.on("--output FILE") { |v| options[:output] = v }
      opts.on("--samples N", Integer) { |v| options[:samples] = v }
      opts.on("--engine NAME", ENGINES.keys) { |v| options[:engine] = v }
    end.parse!(argv)
    raise OptionParser::InvalidArgument, "--samples must be >= 1" if options[:samples] < 1

    options
  rescue OptionParser::ParseError => e
    warn "measure_require: #{e.message}"
    exit 2
  end

  def run_child(engine)
    env = ENGINES.fetch(engine)
    # Drop engine switches inherited from the caller so --engine decides.
    clean = { "PLURIMATH_OGA" => nil, "PLURIMATH_LEPTRIS" => nil }.merge(env)
    out, err, status = Open3.capture3(clean, RbConfig.ruby, "-I", LIB, "-e", CHILD, LIB,
                                      chdir: ROOT)
    unless status.success?
      warn err
      warn "measure_require: child process failed (#{status})"
      exit 2
    end
    JSON.parse(out.lines.last, symbolize_names: true)
  end

  def median(values)
    sorted = values.sort
    mid = sorted.size / 2
    sorted.size.odd? ? sorted[mid] : ((sorted[mid - 1] + sorted[mid]) / 2.0).round(1)
  end

  VARYING = %i[wall_ms allocated_objects rss_growth_kb].freeze

  def summarize_phase(samples, phase)
    phases = samples.map { |s| s.fetch(phase) }
    stable = phases.map { |p| p.except(*VARYING) }
    raise CountMismatch, "#{phase} counts differ between samples" unless stable.uniq.size == 1

    result = stable.first.dup
    VARYING.each do |key|
      values = phases.map { |p| p.fetch(key) }
      result[key] = median(values)
      result[:"#{key}_min"] = values.min
      result[:"#{key}_max"] = values.max
    end
    result
  end

  class CountMismatch < StandardError; end

  def static_autoloads
    per_file = {}
    Dir.glob(File.join(LIB, "**", "*.rb")).each do |path|
      count = File.foreach(path).count { |line| line.match?(/^\s*autoload\s+:/) }
      per_file[path.delete_prefix("#{ROOT}/")] = count if count.positive?
    end
    {
      declared: per_file.values.sum,
      files_declaring: per_file.size,
      lib_ruby_files: Dir.glob(File.join(LIB, "**", "*.rb")).size,
      top_files: per_file.sort_by { |path, count| [-count, path] }.first(10).to_h,
    }
  end

  def source_identity
    commit, = Open3.capture2("git", "-C", ROOT, "rev-parse", "HEAD")
    dirty, = Open3.capture2("git", "-C", ROOT, "status", "--porcelain", "--", "lib", "Gemfile",
                            "plurimath.gemspec")
    { commit: ENV["GITHUB_SHA"] || commit.strip, lib_dirty: !dirty.strip.empty? }
  rescue SystemCallError
    { commit: ENV.fetch("GITHUB_SHA", nil), lib_dirty: nil }
  end

  def environment(first)
    {
      ruby: RUBY_DESCRIPTION,
      platform: RUBY_PLATFORM,
      bundler: defined?(Bundler) ? Bundler::VERSION : nil,
      processors: Etc.nprocessors,
      runner_image: [ENV.fetch("ImageOS", nil), ENV.fetch("ImageVersion", nil)].compact.join(" ").then { |s| s.empty? ? nil : s },
      xml_engine: first[:xml_engine],
      plurimath_version: first[:plurimath_version],
      gems: first[:gems].transform_keys(&:to_s).sort.to_h,
    }
  end

  def deep_sort(value)
    case value
    when Hash then value.transform_keys(&:to_s).sort.to_h.transform_values { |v| deep_sort(v) }
    when Array then value.map { |v| deep_sort(v) }
    else value
    end
  end

  def call(argv)
    options = parse_options(argv)
    samples = Array.new(options[:samples]) { run_child(options[:engine]) }
    first = samples.first
    %i[pending_after_require pending_after_use].each do |key|
      raise CountMismatch, "#{key} differs between samples" unless samples.map { |s| s[key] }.uniq.size == 1
    end

    report = deep_sort(
      schema: SCHEMA,
      samples: options[:samples],
      engine: options[:engine],
      source: source_identity,
      environment: environment(first),
      require: summarize_phase(samples, :require),
      first_use: summarize_phase(samples, :first_use),
      autoload: {
        static: static_autoloads,
        pending_after_require: first[:pending_after_require].size,
        pending_after_first_use: first[:pending_after_use].size,
        namespaces_walked_after_require: first[:modules_after_require],
        namespaces_walked_after_first_use: first[:modules_after_use],
        pending_after_require_names: first[:pending_after_require],
      },
    )
    json = "#{JSON.pretty_generate(report)}\n"
    if options[:output]
      File.write(options[:output], json)
    else
      $stdout.write(json)
    end
    0
  rescue CountMismatch => e
    warn "measure_require: #{e.message}"
    1
  end
end

exit MeasureRequire.call(ARGV) if $PROGRAM_NAME == __FILE__
