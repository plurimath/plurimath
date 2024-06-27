require "spec_helper"
require "plurimath/cli"

RSpec.describe Plurimath::Cli do
  describe ".convert" do
    context "contains no argument" do
      let(:options) { ["convert"] }

      it "should match exit status" do
        expect do
          described_class.start(options)
        end.to raise_error(SystemExit) { |error| expect(error.status).to eq(1) }
      end
    end

    context "contains input argument only" do
      let(:mathml) do
        <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mo>&#x2211;</mo>
            </mstyle>
          </math>
        MATHML
      end

      it "should match mathml output string" do
        expect do
          described_class.start(["convert", "-i", "sum"])
        end.to output(mathml).to_stdout
      end
    end

    context "contains input, input language, and output language arguments" do
      let(:mathml) do
        <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mo>&#x2211;</mo>
            </mstyle>
          </math>
        MATHML
      end

      it "should match mathml output string" do
        expect do
          described_class.start(["convert", "-i", mathml, "-f", "mathml", "-t", "latex"])
        end.to output("\\sum\n").to_stdout
      end
    end

    context "contains file input, input language, and output language arguments" do
      let(:mathml) do
        <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <msub>
                <mfrac>
                  <mi>s</mi>
                  <mi>c</mi>
                </mfrac>
                <mi>d</mi>
              </msub>
            </mstyle>
          </math>
        MATHML
      end

      it "should match mathml output string" do
        file_path = "spec/plurimath/fixtures/executables/power_base.tex"
        options = ["convert", "-p", file_path, "-f", "latex", "-t", "mathml"]
        expect{described_class.start(options)}.to output(mathml).to_stdout
      end
    end
  end
end
