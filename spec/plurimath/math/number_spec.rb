require "spec_helper"
require "support/shared_renderer_examples"

RSpec.describe Plurimath::Math::Number do
  around do |example|
    previous_formatter = Plurimath.configuration.number_formatter
    example.run
  ensure
    Plurimath.configuration.number_formatter = previous_formatter
  end

  describe ".initialize" do
    it "returns instance of Number" do
      number = described_class.new(100)
      expect(number).to be_a(described_class)
    end

    it "initializes Number object" do
      number = described_class.new(100)
      expect(number.value).to be(100)
    end

    it "defaults base to nil" do
      number = described_class.new("255")
      expect(number.base).to be_nil
    end

    it "stores base attribute" do
      number = described_class.new("FF", base: 16)
      expect(number.base).to eq(16)
    end

    it "defaults mini_sub_sized to false" do
      number = described_class.new("1")
      expect(number.mini_sub_sized).to be(false)
    end

    it "defaults mini_sup_sized to false" do
      number = described_class.new("1")
      expect(number.mini_sup_sized).to be(false)
    end
  end

  describe ".to_asciimath" do
    subject(:number) { described_class.new(value) }

    it_behaves_like "shared renderer fixture", "renderer-math-number-number-46-1"
    it_behaves_like "shared renderer fixture", "renderer-math-number-number-46-2"
  end

  it_behaves_like "shared renderer fixture", "renderer-math-number-number-59-1"
  it_behaves_like "shared renderer fixture", "renderer-math-number-number-59-2"
  it_behaves_like "shared renderer fixture", "renderer-math-number-number-59-3"

  describe ".==" do
    subject(:number) { described_class.new(value) }

    context "contains a number string" do
      let(:value) { "1" }

      expected_value = described_class.new("1")

      it "returns string" do
        expect(number == expected_value).to be_truthy
      end
    end

    context "contains a nil string" do
      let(:value) { "" }

      expected_value = described_class.new("1")

      it "returns string" do
        expect(number == expected_value).to be_falsey
      end
    end

    it "returns false for non-Number objects" do
      number = described_class.new("42")
      expect(number == "42").to be_falsey
    end

    it "compares base attribute" do
      a = described_class.new("255", base: 16)
      b = described_class.new("255", base: 10)
      expect(a == b).to be_falsey
    end
  end

  describe ".to_asciimath" do
    subject(:formula) do
      described_class.new(first_value).to_asciimath(options: {})
    end

    it_behaves_like "shared renderer fixture", "renderer-math-number-number-117-1"

    it_behaves_like "shared renderer fixture", "renderer-math-number-number-125-1"
  end

  describe ".to_mathml" do
    subject(:formula) do
      Plurimath.xml_engine.dump(
        described_class.new(first_value)
          .to_mathml_without_math_tag(false, options: {}),
        indent: 2,
      ).gsub("&amp;", "&")
    end

    it_behaves_like "shared renderer fixture", "renderer-math-number-number-143-1"
  end

  describe ".to_latex" do
    subject(:formula) { described_class.new(first_value).to_latex(options: {}) }

    it_behaves_like "shared renderer fixture", "renderer-math-number-number-155-1"

    it_behaves_like "shared renderer fixture", "renderer-math-number-number-163-1"

    context "with configured number formatter" do
      let(:first_value) { "1234" }

      it_behaves_like "shared renderer fixture", "renderer-math-number-number-174-1"

      it "keeps explicit formatter precedence" do
        configured_formatter = Class.new(Plurimath::NumberFormatter) do
          def formatted_number(number_string, format: {})
            "configured #{number_string}"
          end
        end

        Plurimath.configuration.number_formatter = configured_formatter.new
        explicit_formatter = Plurimath::Formatter::Standard.new

        result = described_class.new(first_value).to_latex(
          options: { formatter: explicit_formatter },
        )

        expect(result).to eql("1,234")
      end

      it_behaves_like "shared renderer fixture", "renderer-math-number-number-197-1"

      it_behaves_like "shared renderer fixture", "renderer-math-number-number-216-1"

      it "does not break custom formatters when options[:format] is absent" do
        custom = Class.new(Plurimath::NumberFormatter) do
          def formatted_number(number_string, format: {})
            "custom(#{number_string})"
          end
        end
        result = described_class.new("1234").to_asciimath(
          options: { formatter: custom.new },
        )

        expect(result).to eql("custom(1234)")
      end
    end

    it_behaves_like "shared renderer fixture", "renderer-math-number-number-239-1"
  end

  describe ".to_omml" do
    subject(:formula) do
      Plurimath.xml_engine.dump(
        described_class.new(first_value)
          .to_omml_without_math_tag(true, options: {}).first,
        indent: 2,
      ).gsub("&amp;", "&")
    end

    it_behaves_like "shared renderer fixture", "renderer-math-number-number-257-1"
  end

  describe ".to_html" do
    subject(:formula) { described_class.new(first_value).to_html(options: {}) }

    it_behaves_like "shared renderer fixture", "renderer-math-number-number-269-1"

    it_behaves_like "shared renderer fixture", "renderer-math-number-number-277-1"
  end

  describe ".validate_function_formula" do
    subject(:formula) do
      described_class.new(first_value).validate_function_formula
    end

    context "contains Number as value" do
      let(:first_value) { "80" }

      it "expects false in return" do
        expect(formula).to be(false)
      end
    end

    context "contains Number as value" do
      let(:first_value) { "80" }

      it "does not return true" do
        expect(formula).not_to eql(true)
      end
    end
  end

  describe "semantic base notation rendering" do
    let(:hex_formatter) do
      Plurimath::Formatter::Standard.new(options: { base: 16 })
    end
    let(:bin_formatter) do
      Plurimath::Formatter::Standard.new(options: { base: 2 })
    end
    let(:oct_formatter) do
      Plurimath::Formatter::Standard.new(options: { base: 8 })
    end
    let(:plus_hex_formatter) do
      Plurimath::Formatter::Standard.new(options: { base: 16,
                                                    number_sign: :plus })
    end

    around do |example|
      previous_formatter = Plurimath.configuration.number_formatter
      example.run
    ensure
      Plurimath.configuration.number_formatter = previous_formatter
    end

    it_behaves_like "shared renderer fixture", "renderer-math-number-number-330-1"
    it_behaves_like "shared renderer fixture", "renderer-math-number-number-330-2"
    it_behaves_like "shared renderer fixture", "renderer-math-number-number-330-3"
    it_behaves_like "shared renderer fixture", "renderer-math-number-number-330-4"
    it_behaves_like "shared renderer fixture", "renderer-math-number-number-330-5"
    it_behaves_like "shared renderer fixture", "renderer-math-number-number-330-6"
    it_behaves_like "shared renderer fixture", "renderer-math-number-number-330-7"
    it_behaves_like "shared renderer fixture", "renderer-math-number-number-330-8"

    it_behaves_like "shared renderer fixture", "renderer-math-number-number-424-1"
    it_behaves_like "shared renderer fixture", "renderer-math-number-number-424-2"
    it_behaves_like "shared renderer fixture", "renderer-math-number-number-424-3"
    it_behaves_like "shared renderer fixture", "renderer-math-number-number-424-4"
    it_behaves_like "shared renderer fixture", "renderer-math-number-number-424-5"
    it_behaves_like "shared renderer fixture", "renderer-math-number-number-424-6"

    it_behaves_like "shared renderer fixture", "renderer-math-number-number-462-1"
    it_behaves_like "shared renderer fixture", "renderer-math-number-number-462-2"
    it_behaves_like "shared renderer fixture", "renderer-math-number-number-462-3"
    it_behaves_like "shared renderer fixture", "renderer-math-number-number-462-4"
    it_behaves_like "shared renderer fixture", "renderer-math-number-number-462-5"

    it_behaves_like "shared renderer fixture", "renderer-math-number-number-494-1"
    it_behaves_like "shared renderer fixture", "renderer-math-number-number-494-2"
    it_behaves_like "shared renderer fixture", "renderer-math-number-number-494-3"
    it_behaves_like "shared renderer fixture", "renderer-math-number-number-494-4"
    it_behaves_like "shared renderer fixture", "renderer-math-number-number-494-5"

    it_behaves_like "shared renderer fixture", "renderer-math-number-number-526-1"
    it_behaves_like "shared renderer fixture", "renderer-math-number-number-526-2"
    it_behaves_like "shared renderer fixture", "renderer-math-number-number-526-3"
    it_behaves_like "shared renderer fixture", "renderer-math-number-number-526-4"
    it_behaves_like "shared renderer fixture", "renderer-math-number-number-526-5"

    it_behaves_like "shared renderer fixture", "renderer-math-number-number-558-1"
    it_behaves_like "shared renderer fixture", "renderer-math-number-number-558-2"
    it_behaves_like "shared renderer fixture", "renderer-math-number-number-558-3"
    it_behaves_like "shared renderer fixture", "renderer-math-number-number-558-4"
  end

  describe "stored base attribute" do
    around do |example|
      previous_formatter = Plurimath.configuration.number_formatter
      example.run
    ensure
      Plurimath.configuration.number_formatter = previous_formatter
    end

    it_behaves_like "shared renderer fixture", "renderer-math-number-number-617-1"

    # stored base (16) is the semantic truth about the number
    it_behaves_like "shared renderer fixture", "renderer-math-number-number-624-1"
  end
end
