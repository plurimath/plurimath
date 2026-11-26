require "spec_helper"

RSpec.describe Plurimath::Math::SvgRenderer do
  # Plain stub (not an rspec double): every example runs once per XML engine
  # and a double would leak between those runs.
  let(:stub_class) do
    Class.new do
      attr_reader :calls

      def initialize(result = "<svg/>", error: nil)
        @result = result
        @error = error
        @calls = []
      end

      def render_svg(mathml, **opts)
        @calls << [mathml, opts]
        raise @error if @error

        @result
      end
    end
  end
  let(:formula) { Plurimath::Math.parse("x^2", :asciimath) }

  after { described_class.backend = nil }

  context "without a backend" do
    it "reports unavailability" do
      expect(Plurimath::Math.svg_available?).to be(false)
    end

    it "raises SvgBackendUnavailable from Formula#to_svg" do
      expect { formula.to_svg }
        .to raise_error(Plurimath::Errors::SvgBackendUnavailable,
                        /registered SVG backend/)
    end
  end

  context "with a stub backend" do
    let(:backend) { stub_class.new }

    before { described_class.backend = backend }

    it "reports availability" do
      expect(Plurimath::Math.svg_available?).to be(true)
    end

    it "passes the MathML and backend options, and returns the SVG" do
      expect(formula.to_svg(font_size: 18)).to eq("<svg/>")
      mathml, opts = backend.calls.last
      expect(mathml).to include("<math")
      expect(opts).to eq(font_size: 18)
    end

    it "keeps MathML options away from the backend" do
      formula.to_svg(display_style: false, split_on_linebreak: true)
      expect(backend.calls.last.last).to eq({})
    end

    it "wraps backend errors in RenderingFailed" do
      described_class.backend = stub_class.new(error: RuntimeError.new("boom"))
      expect { formula.to_svg }
        .to raise_error(Plurimath::Errors::RenderingFailed)
    end

    it "rejects a non-String result" do
      described_class.backend = stub_class.new(nil)
      expect { formula.to_svg }
        .to raise_error(Plurimath::Errors::RenderingFailed)
    end
  end

  it "rejects a backend without render_svg" do
    expect { described_class.backend = Object.new }
      .to raise_error(ArgumentError, /render_svg/)
  end
end
