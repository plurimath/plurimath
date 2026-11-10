require "open3"
require "rbconfig"

# Load state is process-global, so each example runs a fresh Ruby process.
RSpec.describe Plurimath::Formatter, if: RUBY_ENGINE != "opal" do
  lib = File.expand_path("../../lib", __dir__)

  define_method(:run_ruby) do |code|
    out, err, status = Open3.capture3(
      RbConfig.ruby, "-I#{lib}", "-e", "require 'plurimath'\n#{code}"
    )
    expect(status).to be_success, err
    out.lines.map(&:chomp)
  end

  let(:formatter_loaded) do
    '$LOADED_FEATURES.any? { |f| f.include?("/plurimath/formatter") }'
  end
  let(:writers) do
    "%i[to_asciimath to_latex to_mathml to_omml to_html to_unicodemath]"
  end

  it "does not load the formatter on require" do
    expect(run_ruby("p Plurimath.autoload?(:Formatter); p #{formatter_loaded}"))
      .to eq(['"plurimath/formatter"', "false"])
  end

  it "does not load the formatter when numbers are written without one" do
    lines = run_ruby(
      'f = Plurimath::Math.parse("x^2 + 3.14", :asciimath); ' \
      "#{writers}.each { |w| f.public_send(w) }; " \
      "p #{formatter_loaded}; p f.to_latex",
    )
    expect(lines).to eq(["false", '"x^{2} + 3.14"'])
  end

  it "loads the formatter when a number formatter is passed" do
    lines = run_ruby(
      'f = Plurimath::Math.parse("1234567.891", :asciimath); ' \
      "p #{formatter_loaded}; " \
      'fmt = Plurimath::NumberFormatter.new("en", ' \
      'localize_number: "#,##0.### ###"); ' \
      "p f.to_asciimath(formatter: fmt); p #{formatter_loaded}",
    )
    expect(lines).to eq(["false", '"1,234,567.891"', "true"])
  end

  it "loads the formatter when a configured locale is read" do
    lines = run_ruby(
      "Plurimath.configuration.locale = :fr; " \
      "p Plurimath.configuration.decimal; p #{formatter_loaded}",
    )
    expect(lines).to eq(['","', "true"])
  end
end
