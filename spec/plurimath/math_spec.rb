require "spec_helper"

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

      it "uses the configured locale while parsing through the facade" do
        expected_value = Plurimath::Math::Formula.new([
                                                        Plurimath::Math::Number.new("1,2"),
                                                      ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when locale is passed as a parse option" do
      let(:input) { "1,2" }
      let(:type) { "asciimath" }
      let(:parse_options) { { locale: :fr } }

      it "uses the locale while parsing through the facade" do
        expected_value = Plurimath::Math::Formula.new([
                                                        Plurimath::Math::Number.new("1,2"),
                                                      ])
        expect(formula).to eq(expected_value)
      end
    end

    context "when locale is passed as a parse option for other localized parsers" do
      it "uses locale for HTML input" do
        expected_value = Plurimath::Math::Formula.new([
                                                        Plurimath::Math::Number.new("1,2"),
                                                      ])

        expect(described_class.parse("1,2", :html, locale: :fr)).to eq(expected_value)
      end

      it "uses locale for LaTeX input" do
        expected_value = Plurimath::Math::Formula.new([
                                                        Plurimath::Math::Number.new("1,2"),
                                                      ])

        expect(described_class.parse("1,2", :latex, locale: :fr)).to eq(expected_value)
      end

      it "uses locale for UnicodeMath input" do
        expected_value = Plurimath::Math::Formula.new([
                                                        Plurimath::Math::Number.new("1٫2"),
                                                      ])

        expect(described_class.parse("1٫2", :unicode, locale: :ar)).to eq(expected_value)
      end
    end

    context "when locale is passed as a parse option with persistent configuration" do
      it "uses the parse option without mutating the shared configuration" do
        previous_locale = Plurimath.configuration.locale
        Plurimath.configuration.locale = :en

        localized = described_class.parse("1,2", :asciimath, locale: :fr)
        defaulted = described_class.parse("1,2", :asciimath)

        expect(localized).to eq(
          Plurimath::Math::Formula.new([
                                         Plurimath::Math::Number.new("1,2"),
                                       ]),
        )
        expect(defaulted.to_asciimath).to eq("1 , 2")
        expect(Plurimath.configuration.locale).to be(:en)
      ensure
        Plurimath.configuration.locale = previous_locale
      end

      it "uses an explicit nil locale without mutating the shared configuration" do
        previous_locale = Plurimath.configuration.locale
        Plurimath.configuration.locale = :fr

        defaulted = described_class.parse("1,2", :asciimath, locale: nil)

        expect(defaulted.to_asciimath).to eq("1 , 2")
        expect(Plurimath.configuration.locale).to be(:fr)
      ensure
        Plurimath.configuration.locale = previous_locale
      end
    end

    context "when an unknown parse option is provided" do
      let(:input) { "1,2" }
      let(:type) { "asciimath" }
      let(:parse_options) { { local: :fr } }

      it "raises a parse option error" do
        expect { formula }.to raise_error(
          Plurimath::Math::ParseOptionError,
          "unknown parse option: :local; supported parse options are :locale",
        )
      end
    end

    context "when a parse option is unsupported by the parser type" do
      it "raises a parse option error" do
        expect do
          described_class.parse("<math></math>", :mathml, locale: :fr)
        end.to raise_error(
          Plurimath::Math::ParseOptionError,
          "parse option :locale is not supported for :mathml; " \
          "supported input types are :asciimath, :html, :latex, :unicode",
        )
      end
    end

    context "when an unsupported locale is provided" do
      it "raises a formatter locale error" do
        expect do
          described_class.parse("1,2", :asciimath, locale: :unknown)
        end.to raise_error(
          Plurimath::Formatter::UnsupportedLocale,
          /\[plurimath\] Unsupported locale :unknown\./,
        )
      end
    end

    context "contains incorrect type with parseable input of asciimath" do
      let(:input) { "sin(d)" }
      let(:type) { "wrong_type" }

      it "raises error on wrong type" do
        expect { formula }.to raise_error(Plurimath::Math::InvalidTypeError)
      end
    end

    context "contains correct type with incomplete input of latex" do
      let(:input) { '{\sin{d}' }
      let(:type) { "latex" }

      it "raises error on wrong text input" do
        message = "Failed to parse the following formula with type `#{type}`"
        expect { formula }.to raise_error(
          Plurimath::Math::ParseError, Regexp.compile(message)
        )
      end
    end

    context "contains correct input string and custom invalid formula" do
      it "raises error on wrong text input" do
        formula = Plurimath::Math::Formula.new([
                                                 Plurimath::Math::Function::Sin.new("d"),
                                               ])
        expect { formula.to_html }.to raise_error(Plurimath::Math::ParseError)
        expect { formula.to_omml }.to raise_error(Plurimath::Math::ParseError)
        expect { formula.to_latex }.to raise_error(Plurimath::Math::ParseError)
        expect { formula.to_mathml }.to raise_error(Plurimath::Math::ParseError)
        expect { formula.to_asciimath }.to raise_error(Plurimath::Math::ParseError)
        expect { formula.to_unicodemath }.to raise_error(Plurimath::Math::ParseError)
      end
    end

    context "preserves specialized error types from lower layers" do
      let(:input) { "mm^(b)" }
      let(:type) { "unitsml" }

      it "raises error with specialized unitsml error message" do
        message = "The use of a variable as an exponent is not valid."
        expect { formula }.to raise_error(
          Plurimath::Math::ParseError, Regexp.compile(message)
        )
      end
    end
  end

  describe ".render" do
    it "raises an actionable RenderingError when lasem is unavailable" do
      allow(Plurimath::Math::Renderer).to receive(:available?).and_return(false)
      expect { described_class.render("sum", "asciimath", format: :svg) }
        .to raise_error(Plurimath::RenderingError, /lasem-doctor/)
    end

    it "raises a RenderingError for an unsupported format" do
      expect { described_class.render("sum", "asciimath", format: :gif) }
        .to raise_error(Plurimath::RenderingError, /unsupported render format/)
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
