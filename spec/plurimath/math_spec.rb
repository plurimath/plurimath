require "spec_helper"
require_relative "../support/shared_facade_examples"

RSpec.describe Plurimath::Math do
  describe ".initialize" do
    subject(:formula) { described_class.parse(input, type, **parse_options) }

    let(:parse_options) { {} }

    context "when persistent configuration sets a locale" do
      let(:input) { "1,2" }
      let(:type) { "asciimath" }

      around do |example|
        previous_locale = Plurimath.configuration.locale
        Plurimath.configure do |config|
          config.locale = :fr
        end
        example.run
      ensure
        Plurimath.configuration.locale = previous_locale
      end

      it_behaves_like "shared facade expectation", "facade-math-23"
    end

    context "when locale is passed as a parse option" do
      let(:input) { "1,2" }
      let(:type) { "asciimath" }
      let(:parse_options) { { locale: :fr } }

      it_behaves_like "shared facade expectation", "facade-math-36"
    end

    context "when locale is passed as a parse option for other localized parsers" do
      it_behaves_like "shared facade expectation", "facade-math-45"

      it_behaves_like "shared facade expectation", "facade-math-54"

      it_behaves_like "shared facade expectation", "facade-math-63"
    end

    context "when locale is passed as a parse option with persistent configuration" do
      it "uses the parse option without mutating the shared configuration" do
        previous_locale = Plurimath.configuration.locale
        Plurimath.configuration.locale = :en

        shared_facade_expectations("facade-math-74")
        expect(Plurimath.configuration.locale).to be(:en)
      ensure
        Plurimath.configuration.locale = previous_locale
      end

      it "uses an explicit nil locale without mutating the shared configuration" do
        previous_locale = Plurimath.configuration.locale
        Plurimath.configuration.locale = :fr

        shared_facade_expectations("facade-math-92")
        expect(Plurimath.configuration.locale).to be(:fr)
      ensure
        Plurimath.configuration.locale = previous_locale
      end
    end

    context "when an unknown parse option is provided" do
      let(:input) { "1,2" }
      let(:type) { "asciimath" }
      let(:parse_options) { { local: :fr } }

      it_behaves_like "shared facade expectation", "facade-math-110"
    end

    context "when a parse option is unsupported by the parser type" do
      it_behaves_like "shared facade expectation", "facade-math-119"
    end

    context "when an unsupported locale is provided" do
      it_behaves_like "shared facade expectation", "facade-math-131"
    end

    context "contains incorrect type with parseable input of asciimath" do
      let(:input) { "sin(d)" }
      let(:type) { "wrong_type" }

      it_behaves_like "shared facade expectation", "facade-math-145"
    end

    context "contains correct type with incomplete input of latex" do
      let(:input) { '{\sin{d}' }
      let(:type) { "latex" }

      it_behaves_like "shared facade expectation", "facade-math-154"
    end

    context "contains correct input string and custom invalid formula" do
      it_behaves_like "shared facade expectation", "facade-math-163"
    end

    context "preserves specialized error types from lower layers" do
      let(:input) { "mm^(b)" }
      let(:type) { "unitsml" }

      it_behaves_like "shared facade expectation", "facade-math-180"
    end
  end

  describe ".render" do
    it "raises RenderingUnavailable when lasem is unavailable" do
      allow(Plurimath::Math::Renderer).to receive(:available?).and_return(false)
      expect { described_class.render("sum", "asciimath", format: :svg) }
        .to raise_error(Plurimath::Errors::RenderingUnavailable, /lasem-doctor/)
    end

    it "raises UnsupportedRenderFormat for an unsupported format" do
      expect { described_class.render("sum", "asciimath", format: :gif) }
        .to raise_error(Plurimath::Errors::UnsupportedRenderFormat, /Unsupported render format/)
    end

    it "parses then renders, forwarding format and geometry to the renderer" do
      allow(Plurimath::Math::Renderer).to receive(:render).and_return("BYTES")
      expect(described_class.render("sum", "asciimath", format: :png, ppi: 144))
        .to eq("BYTES")
      expect(Plurimath::Math::Renderer).to have_received(:render)
        .with(a_string_matching(/<math/), format: :png, ppi: 144)
    end

    it "routes :locale to parsing and the rest to rendering" do
      allow(Plurimath::Math::Renderer).to receive(:render).and_return("X")
      allow(described_class).to receive(:parse).and_call_original
      described_class.render("1,2", "asciimath", format: :svg, locale: :fr)
      expect(described_class).to have_received(:parse)
        .with("1,2", "asciimath", locale: :fr)
    end
  end

  describe ".render_available?" do
    it "delegates to the renderer when available" do
      allow(Plurimath::Math::Renderer).to receive(:available?).and_return(true)
      expect(described_class.render_available?).to be(true)
    end

    it "delegates to the renderer when unavailable" do
      allow(Plurimath::Math::Renderer).to receive(:available?).and_return(false)
      expect(described_class.render_available?).to be(false)
    end

    it "short-circuits to false under Opal without referencing the renderer" do
      allow(Plurimath::Math::Renderer).to receive(:available?)
      stub_const("RUBY_ENGINE", "opal")
      expect(described_class.render_available?).to be(false)
      expect(Plurimath::Math::Renderer).not_to have_received(:available?)
    end
  end
end
