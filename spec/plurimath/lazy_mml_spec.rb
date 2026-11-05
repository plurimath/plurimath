require "open3"
require "rbconfig"

# Load state is process-global, so each example runs a fresh Ruby process.
RSpec.describe Plurimath, ".load_mml", if: RUBY_ENGINE != "opal" do
  lib = File.expand_path("../../lib", __dir__)

  define_method(:run_ruby) do |code|
    out, err, status = Open3.capture3(
      RbConfig.ruby, "-I#{lib}", "-e", "require 'plurimath'\n#{code}"
    )
    expect(status).to be_success, err
    out.lines.map(&:chomp)
  end

  let(:mml_loaded) { '$LOADED_FEATURES.any? { |f| f.end_with?("/mml.rb") }' }
  let(:parse) { 'Plurimath::Math.parse("<math><mi>x</mi></math>", :mathml)' }

  it "does not load mml on require" do
    expect(run_ruby("p autoload?(:Mml); p #{mml_loaded}"))
      .to eq(['"mml"', "false"])
  end

  it "loads mml on the first MathML parse with unchanged output" do
    expected = <<~MATHML.inspect
      <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
        <mstyle displaystyle="true">
          <mi>x</mi>
        </mstyle>
      </math>
    MATHML
    lines = run_ruby("f = #{parse}; p #{mml_loaded}; p f.to_asciimath; " \
                     "p f.to_mathml")
    expect(lines).to eq(["true", '"x"', expected])
  end

  it "applies the require-time adapter when mml_adapter is called first" do
    default = run_ruby("#{parse}; p Mml::V4::Configuration.adapter").last
    lines = run_ruby("Plurimath.mml_adapter(:oga); p #{mml_loaded}; " \
                     "#{parse}; p Mml::V4::Configuration.adapter")
    expect(lines).to eq(["true", default])
    expect(default).not_to eq("nil")
  end

  it "resolves Mml through the autoload" do
    expect(run_ruby("p Mml.is_a?(Module); p #{mml_loaded}"))
      .to eq(%w[true true])
  end
end
