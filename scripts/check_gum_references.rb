# frozen_string_literal: true

require "json"
require "optparse"
require "digest"
$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "plurimath"

options = {}
OptionParser.new do |parser|
  parser.on("--output PATH") { |path| options[:output] = path }
  parser.on("--significant-digits N", Integer) { |n| options[:digits] = n }
  parser.on("--max-samples N", Integer) { |n| options[:max_samples] = n }
end.parse!
abort "provide --output, --significant-digits, --max-samples and one fixture" unless options.keys.sort == %i[digits max_samples output] && ARGV.length == 1
input_path = ARGV.fetch(0)
fixture = JSON.parse(File.read(input_path))
abort "unsupported reference schema" unless fixture.fetch("schema") == "gum-h1-mcm-reference/1"
formula = Plurimath::Math.parse(fixture.fetch("model"), :asciimath)
report = { schema: "gum-h1-execution/1", input_sha256: Digest::SHA256.file(input_path).hexdigest,
           complete: false, cases: [] }
write = -> { File.write(options.fetch(:output), JSON.pretty_generate(report) + "\n") }
write.call
fixture.fetch("cases").each do |profile|
  started = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  row = { id: profile.fetch("id"), source_pdf_sha256: profile.fetch("source_pdf_sha256") }
  report[:cases] << row
  write.call
  begin
    inputs = profile.fetch("inputs").to_h.transform_values do |definition|
      result = definition.transform_keys(&:to_sym)
      result[:distribution] = result.fetch(:distribution).to_sym
      result
    end
    result = Plurimath::Math::Evaluation::Gum.monte_carlo(formula,
             inputs: inputs, independent: true, seeds: profile.fetch("seeds"),
             probability: "0.95", interval: :both, significant_digits: options.fetch(:digits),
             guard_digits: 12, max_samples: options.fetch(:max_samples))
    tolerance = Rational(profile.fetch("reference_check_tolerance_nm"))
    error = (Rational(result.fetch(:standard_uncertainty)) - Rational(profile.fetch("expected_standard_uncertainty_nm"))).abs
    mean_error = (Rational(result.fetch(:estimate)) - Rational(profile.fetch("expected_mean_nm"))).abs
    raise "reference disagreement for #{profile.fetch('id')}" unless error < tolerance && mean_error < tolerance
    row.merge!(passed: true, result: result, uncertainty_error_nm: error.to_s,
               mean_error_nm: mean_error.to_s)
  rescue StandardError => error
    row.merge!(passed: false, error: { class: error.class.name, message: error.message })
    raise
  ensure
    row[:elapsed_seconds] = format("%.3f", Process.clock_gettime(Process::CLOCK_MONOTONIC) - started)
    write.call
  end
end
report[:complete] = true
write.call
puts JSON.generate(report[:cases].map { |row| { id: row[:id], passed: row[:passed], samples: row[:result][:samples] } })
