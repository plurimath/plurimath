require "spec_helper"
require "plurimath/cli"
require "tmpdir"
require "fileutils"

RSpec.describe Plurimath::Cli do
  describe ".convert" do
    context "contains no argument" do
      let(:options) { ["convert"] }

      it "matches exit status" do
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

      it "matches mathml output string" do
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

      it "matches mathml output string" do
        expect do
          described_class.start(["convert", "-i", mathml, "-f", "mathml", "-t",
                                 "latex"])
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

      it "matches mathml output string" do
        file_path = "spec/plurimath/fixtures/executables/power_base.tex"
        options = ["convert", "-p", file_path, "-f", "latex", "-t", "mathml"]
        expect { described_class.start(options) }.to output(mathml).to_stdout
      end
    end
  end

  describe ".render" do
    let(:out_path) do
      File.join(Dir.tmpdir, "plurimath_render_#{Process.pid}.svg")
    end

    after { FileUtils.rm_f(out_path) }

    context "with no input" do
      it "warns and exits non-zero" do
        expect do
          described_class.start(["render", "-o", out_path])
        end.to raise_error(SystemExit) { |error| expect(error.status).to eq(1) }
      end
    end

    context "with an unsupported output extension" do
      it "exits with the unsupported-format message" do
        gif_path = File.join(Dir.tmpdir, "plurimath_render_#{Process.pid}.gif")
        expect do
          described_class.start(["render", "-i", "sum", "-o", gif_path])
        end.to raise_error(SystemExit) { |error| expect(error.status).to eq(1) }
      end
    end

    context "when lasem is unavailable" do
      before { allow(Plurimath::Math::Renderer).to receive(:available?).and_return(false) }

      it "exits with the lasem guidance" do
        expect do
          described_class.start(["render", "-i", "sum", "-o", out_path])
        end.to raise_error(SystemExit) { |error| expect(error.status).to eq(1) }
      end
    end

    context "with the bridge stubbed to succeed" do
      before { allow(Plurimath::Math).to receive(:render).and_return("<svg/>") }

      it "writes the rendered bytes to the --output path" do
        described_class.start(["render", "-i", "sum", "-o", out_path])
        expect(File.binread(out_path)).to eq("<svg/>")
      end

      it "writes bytes to stdout when --output is omitted" do
        expect do
          described_class.start(["render", "-i", "sum", "--format", "svg"])
        end.to output("<svg/>").to_stdout
      end

      it "forwards geometry flags to Math.render" do
        described_class.start(["render", "-i", "sum", "-o", out_path, "--ppi", "144", "--zoom", "2"])
        expect(Plurimath::Math).to have_received(:render)
          .with("sum", "asciimath", hash_including(:ppi, :zoom, format: :svg))
      end
    end

    context "with an unparseable formula" do
      it "warns and exits non-zero (ParseError is caught as Plurimath::Error)" do
        expect do
          described_class.start(["render", "-i", "{\\sin{d}", "-f", "latex", "-o", out_path])
        end.to raise_error(SystemExit) { |error| expect(error.status).to eq(1) }
      end
    end

    context "used as a standalone command object" do
      it "forwards symbol-keyed geometry options into render_options" do
        cmd = Plurimath::Cli::Render.new(
          { input: "sum", input_format: "asciimath", ppi: 144, zoom: 2 },
        )
        expect(cmd.send(:render_options)).to eq(ppi: 144, zoom: 2)
      end
    end

    describe "format resolution" do
      def resolved_format(opts)
        Plurimath::Cli::Render.new(opts).send(:render_format, opts[:output])
      end

      it "lets a supported --output extension win over --format" do
        expect(resolved_format(output: "x.png", format: "svg")).to eq(:png)
      end

      it "uses --format when --output has no extension" do
        expect(resolved_format(output: "x", format: "pdf")).to eq(:pdf)
      end

      it "uses --format for stdout (no --output)" do
        expect(resolved_format(format: "ps")).to eq(:ps)
      end

      it "defaults to :svg for stdout with no --format" do
        expect(resolved_format({})).to eq(:svg)
      end

      it "surfaces an unsupported extension verbatim (so the renderer errors)" do
        expect(resolved_format(output: "x.gif")).to eq(:gif)
      end
    end
  end
end
