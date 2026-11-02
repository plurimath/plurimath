require "spec_helper"

RSpec.describe Plurimath::Math::Formula do
  let(:formula) { Plurimath::Math.parse("sum", "asciimath") }

  describe "#render" do
    it "rejects an unsupported format before touching lasem" do
      expect { formula.render(format: :gif) }
        .to raise_error(Plurimath::Errors::UnsupportedRenderFormat, /Unsupported render format/)
    end

    it "raises RenderingUnavailable when lasem is unavailable" do
      allow(Plurimath::Math::Renderer).to receive(:available?).and_return(false)
      expect { formula.render(format: :svg) }
        .to raise_error(Plurimath::Errors::RenderingUnavailable, /lasem-doctor/)
    end

    context "with the bridge stubbed at the boundary" do
      before { allow(Plurimath::Math::Renderer).to receive(:render).and_return("X") }

      it "serializes to MathML and forwards format + geometry to the renderer" do
        expect(formula.render(format: :png, ppi: 144, zoom: 2)).to eq("X")
        expect(Plurimath::Math::Renderer).to have_received(:render)
          .with(a_string_matching(/<math/), format: :png, ppi: 144, zoom: 2)
      end

      it "honors the formula's display style when display_style is omitted" do
        allow(formula).to receive(:to_mathml).and_call_original
        formula.render(format: :svg)
        expect(formula).to have_received(:to_mathml).with(no_args)
      end

      it "forwards display_style and other to_mathml options when given" do
        allow(formula).to receive(:to_mathml).and_call_original
        formula.render(format: :svg, display_style: false, intent: true)
        expect(formula).to have_received(:to_mathml)
          .with(display_style: false, intent: true)
      end

      it "ignores unrecognized keyword options" do
        allow(formula).to receive(:to_mathml).and_call_original
        expect { formula.render(format: :svg, bogus: 1) }.not_to raise_error
        expect(formula).to have_received(:to_mathml).with(no_args)
      end
    end

    context "with a real native lasem backend", if: Plurimath::Math::Renderer.available? do
      it "produces a non-empty SVG string" do
        out = formula.render(format: :svg)
        expect(out).to be_a(String)
        expect(out).to include("<svg")
      end
    end
  end
end
