require "spec_helper"

RSpec.describe Plurimath::Math::Renderer do
  describe ".normalize_format" do
    it "accepts the four output formats case-insensitively" do
      expect(described_class.normalize_format("SVG")).to eq(:svg)
      %i[svg png pdf ps].each do |fmt|
        expect(described_class.normalize_format(fmt)).to eq(fmt)
      end
    end

    it "raises UnsupportedRenderFormat for an unknown format" do
      expect { described_class.normalize_format(:gif) }
        .to raise_error(Plurimath::Errors::UnsupportedRenderFormat,
                        /\A\[plurimath\] Unsupported render format/)
    end
  end

  describe ".render" do
    it "validates the format before checking availability" do
      # lasem's native extension is unavailable in tests, so an
      # availability-first implementation would raise the "unavailable" error;
      # getting the unsupported-format error proves format is checked first.
      expect { described_class.render("<math/>", format: :gif) }
        .to raise_error(Plurimath::Errors::UnsupportedRenderFormat, /Unsupported render format/)
    end

    it "raises an actionable unavailable error when lasem is absent" do
      allow(described_class).to receive(:available?).and_return(false)
      expect { described_class.render("<math/>", format: :svg) }
        .to raise_error(Plurimath::Errors::RenderingUnavailable,
                        /\A\[plurimath\].*lasem-doctor/)
    end

    context "with a stubbed Lasem backend" do
      let(:fake_lasem) do
        Class.new do
          class << self
            attr_reader :calls

            def render(source, **opts)
              (@calls ||= []) << [source, opts]
              "BYTES"
            end
          end
        end
      end

      before do
        allow(described_class).to receive(:available?).and_return(true)
        stub_const("Lasem", fake_lasem)
      end

      it "calls Lasem with input: :mathml and the normalized output format" do
        expect(described_class.render("<math/>", format: "PNG")).to eq("BYTES")
        expect(fake_lasem.calls.last)
          .to eq(["<math/>", { input: :mathml, output: :png }])
      end

      it "drops nil geometry options so lasem applies its own defaults" do
        described_class.render("<math/>", format: :svg, ppi: 96, zoom: nil)
        expect(fake_lasem.calls.last.last)
          .to eq({ input: :mathml, output: :svg, ppi: 96 })
      end

      it "wraps backend errors (incl. ArgumentError outside Lasem::Error) as RenderingFailed" do
        allow(fake_lasem).to receive(:render).and_raise(ArgumentError, "bad ppi")
        err = nil
        expect { described_class.render("<math/>", format: :svg, ppi: -1) }
          .to raise_error(Plurimath::Errors::RenderingFailed) { |e| err = e }
        expect(err.message).to match(/\A\[plurimath\] Failed to render/)
        expect(err.cause).to be_a(ArgumentError)
      end
    end
  end

  describe ".available?" do
    it "is false under Opal regardless of lasem" do
      stub_const("RUBY_ENGINE", "opal")
      expect(described_class.available?).to be(false)
    end
  end
end
