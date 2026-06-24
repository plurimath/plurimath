require "spec_helper"

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

    context "contains a number string" do
      let(:value) { "1" }

      it "returns string" do
        expect(number.to_asciimath(options: {})).to eq(value)
      end

      it "returns string when formatter is nil" do
        expect(number.to_asciimath(options: { formatter: nil })).to eq(value)
      end
    end
  end

  describe "nil formatter handling" do
    subject(:number) { described_class.new("42") }

    let(:nil_options) { { formatter: nil } }

    it "returns value from to_latex" do
      expect(number.to_latex(options: nil_options)).to eq("42")
    end

    it "returns value from to_html" do
      expect(number.to_html(options: nil_options)).to eq("42")
    end

    it "returns value from to_unicodemath" do
      expect(number.to_unicodemath(options: nil_options)).to eq("42")
    end
  end

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

    context "contains Single Number as value" do
      let(:first_value) { "1" }

      it "returns asciimath string" do
        expect(formula).to eq("1")
      end
    end

    context "contains Decimal Number as value" do
      let(:first_value) { "70.8" }

      it "returns asciimath string" do
        expect(formula).to eq("70.8")
      end
    end
  end

  describe ".to_mathml" do
    subject(:formula) do
      Plurimath.xml_engine.dump(
        described_class.new(first_value)
          .to_mathml_without_math_tag(false, options: {}),
        indent: 2,
      ).gsub("&amp;", "&")
    end

    context "contains Number as value" do
      let(:first_value) { "70" }

      it "returns mathml string" do
        expect(formula).to be_xml_equivalent_to("<mn>70</mn>")
      end
    end
  end

  describe ".to_latex" do
    subject(:formula) { described_class.new(first_value).to_latex(options: {}) }

    context "contains Symbol as value" do
      let(:first_value) { "n" }

      it "returns mathml string" do
        expect(formula).to eql("n")
      end
    end

    context "contains Number as value" do
      let(:first_value) { "70" }

      it "returns mathml string" do
        expect(formula).to eql("70")
      end
    end

    context "with configured number formatter" do
      let(:first_value) { "1234" }

      it "formats the number" do
        Plurimath.configuration.number_formatter = Plurimath::Formatter::Standard.new

        expect(formula).to eql("1,234")
      end

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

      it "forwards options[:format] to the formatter's per-call format override" do
        formatter = Plurimath::Formatter::Standard.new
        result = described_class.new("23456").to_asciimath(
          options: {
            formatter: formatter,
            format: {
              base: 16,
              base_prefix: "U+",
              group: "",
              padding_group_digits: 4,
              hex_capital: true,
              significant: 4,
            },
          },
        )

        expect(result).to eql("U+5BA0")
      end

      it "does not forward an empty options[:format] hash" do
        formatter = Plurimath::Formatter::Standard.new
        result = described_class.new("1234").to_asciimath(
          options: { formatter: formatter, format: {} },
        )

        expect(result).to eql("1,234")
      end

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

    context "with nil formatter" do
      let(:first_value) { "42" }

      it "returns raw value" do
        expect(formula).to eql("42")
      end
    end
  end

  describe ".to_omml" do
    subject(:formula) do
      Plurimath.xml_engine.dump(
        described_class.new(first_value)
          .to_omml_without_math_tag(true, options: {}).first,
        indent: 2,
      ).gsub("&amp;", "&")
    end

    context "contains Number as value" do
      let(:first_value) { "70" }

      it "returns mathml string" do
        expect(formula).to be_xml_equivalent_to("<m:t>70</m:t>")
      end
    end
  end

  describe ".to_html" do
    subject(:formula) { described_class.new(first_value).to_html(options: {}) }

    context "contains Symbol as value" do
      let(:first_value) { "n" }

      it "returns html string" do
        expect(formula).to be_xml_equivalent_to("n")
      end
    end

    context "contains Number as value" do
      let(:first_value) { "70" }

      it "returns html string" do
        expect(formula).to be_xml_equivalent_to("70")
      end
    end
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

    describe "to_mathml_without_math_tag" do
      it "produces msub for base 16" do
        Plurimath.configuration.number_formatter = hex_formatter
        xml = Plurimath.xml_engine.dump(
          described_class.new("255").to_mathml_without_math_tag(false,
                                                                options: {}),
          indent: 2,
        )

        expect(xml).to be_xml_equivalent_to("<msub><mn>ff</mn><mn>16</mn></msub>")
      end

      it "produces msub for base 2" do
        Plurimath.configuration.number_formatter = bin_formatter
        xml = Plurimath.xml_engine.dump(
          described_class.new("10").to_mathml_without_math_tag(false,
                                                               options: {}),
          indent: 2,
        )

        expect(xml).to be_xml_equivalent_to("<msub><mn>1,010</mn><mn>2</mn></msub>")
      end

      it "produces msub for base 8" do
        Plurimath.configuration.number_formatter = oct_formatter
        xml = Plurimath.xml_engine.dump(
          described_class.new("15").to_mathml_without_math_tag(false,
                                                               options: {}),
          indent: 2,
        )

        expect(xml).to be_xml_equivalent_to("<msub><mn>17</mn><mn>8</mn></msub>")
      end

      it "wraps negative numbers in mrow with mo sign" do
        Plurimath.configuration.number_formatter = hex_formatter
        xml = Plurimath.xml_engine.dump(
          described_class.new("-255").to_mathml_without_math_tag(false,
                                                                 options: {}),
          indent: 2,
        )

        expect(xml).to be_xml_equivalent_to(
          "<mrow><mo>-</mo><msub><mn>ff</mn><mn>16</mn></msub></mrow>",
        )
      end

      it "wraps explicit plus in mrow with mo sign" do
        Plurimath.configuration.number_formatter = plus_hex_formatter
        xml = Plurimath.xml_engine.dump(
          described_class.new("255").to_mathml_without_math_tag(false,
                                                                options: {}),
          indent: 2,
        )

        expect(xml).to be_xml_equivalent_to(
          "<mrow><mo>+</mo><msub><mn>ff</mn><mn>16</mn></msub></mrow>",
        )
      end

      it "includes decimal point in digit mn element" do
        Plurimath.configuration.number_formatter = hex_formatter
        xml = Plurimath.xml_engine.dump(
          described_class.new("15.5").to_mathml_without_math_tag(false,
                                                                 options: {}),
          indent: 2,
        )

        expect(xml).to be_xml_equivalent_to("<msub><mn>f.8</mn><mn>16</mn></msub>")
      end

      it "falls back to mn for base 10" do
        Plurimath.configuration.number_formatter = Plurimath::Formatter::Standard.new
        xml = Plurimath.xml_engine.dump(
          described_class.new("42").to_mathml_without_math_tag(false,
                                                               options: {}),
          indent: 2,
        )

        expect(xml).to be_xml_equivalent_to("<mn>42</mn>")
      end

      it "falls back to mn without formatter" do
        Plurimath.configuration.number_formatter = nil
        xml = Plurimath.xml_engine.dump(
          described_class.new("255").to_mathml_without_math_tag(false,
                                                                options: {}),
          indent: 2,
        )

        expect(xml).to be_xml_equivalent_to("<mn>255</mn>")
      end
    end

    describe "to_latex" do
      it "produces subscript for base 16" do
        Plurimath.configuration.number_formatter = hex_formatter

        expect(described_class.new("255").to_latex(options: {})).to eq("\\mathrm{ff}_{16}")
      end

      it "produces subscript for base 2" do
        Plurimath.configuration.number_formatter = bin_formatter

        expect(described_class.new("10").to_latex(options: {})).to eq("\\mathrm{1,010}_{2}")
      end

      it "prepends minus sign for negative numbers" do
        Plurimath.configuration.number_formatter = hex_formatter

        expect(described_class.new("-255").to_latex(options: {})).to eq("-\\mathrm{ff}_{16}")
      end

      it "prepends plus sign when number_sign is :plus" do
        Plurimath.configuration.number_formatter = plus_hex_formatter

        expect(described_class.new("255").to_latex(options: {})).to eq("+\\mathrm{ff}_{16}")
      end

      it "includes decimal point in digits" do
        Plurimath.configuration.number_formatter = hex_formatter

        expect(described_class.new("15.5").to_latex(options: {})).to eq("\\mathrm{f.8}_{16}")
      end

      it "returns plain string for base 10" do
        Plurimath.configuration.number_formatter = Plurimath::Formatter::Standard.new

        expect(described_class.new("42").to_latex(options: {})).to eq("42")
      end
    end

    describe "to_asciimath" do
      it "produces subscript for base 16" do
        Plurimath.configuration.number_formatter = hex_formatter

        expect(described_class.new("255").to_asciimath(options: {})).to eq("ff_(16)")
      end

      it "produces subscript for base 2" do
        Plurimath.configuration.number_formatter = bin_formatter

        expect(described_class.new("10").to_asciimath(options: {})).to eq("1,010_(2)")
      end

      it "prepends minus sign for negative numbers" do
        Plurimath.configuration.number_formatter = hex_formatter

        expect(described_class.new("-255").to_asciimath(options: {})).to eq("-ff_(16)")
      end

      it "prepends plus sign when number_sign is :plus" do
        Plurimath.configuration.number_formatter = plus_hex_formatter

        expect(described_class.new("255").to_asciimath(options: {})).to eq("+ff_(16)")
      end

      it "returns plain string for base 10" do
        Plurimath.configuration.number_formatter = Plurimath::Formatter::Standard.new

        expect(described_class.new("42").to_asciimath(options: {})).to eq("42")
      end
    end

    describe "to_html" do
      it "produces sub tag for base 16" do
        Plurimath.configuration.number_formatter = hex_formatter

        expect(described_class.new("255").to_html(options: {})).to eq("ff<sub>16</sub>")
      end

      it "produces sub tag for base 2" do
        Plurimath.configuration.number_formatter = bin_formatter

        expect(described_class.new("10").to_html(options: {})).to eq("1,010<sub>2</sub>")
      end

      it "prepends minus sign for negative numbers" do
        Plurimath.configuration.number_formatter = hex_formatter

        expect(described_class.new("-255").to_html(options: {})).to eq("-ff<sub>16</sub>")
      end

      it "prepends plus sign when number_sign is :plus" do
        Plurimath.configuration.number_formatter = plus_hex_formatter

        expect(described_class.new("255").to_html(options: {})).to eq("+ff<sub>16</sub>")
      end

      it "returns plain string for base 10" do
        Plurimath.configuration.number_formatter = Plurimath::Formatter::Standard.new

        expect(described_class.new("42").to_html(options: {})).to eq("42")
      end
    end

    describe "to_unicodemath" do
      it "produces subscript for base 16" do
        Plurimath.configuration.number_formatter = hex_formatter

        expect(described_class.new("255").to_unicodemath(options: {})).to eq("ff_(16)")
      end

      it "produces subscript for base 2" do
        Plurimath.configuration.number_formatter = bin_formatter

        expect(described_class.new("10").to_unicodemath(options: {})).to eq("1,010_(2)")
      end

      it "prepends minus sign for negative numbers" do
        Plurimath.configuration.number_formatter = hex_formatter

        expect(described_class.new("-255").to_unicodemath(options: {})).to eq("-ff_(16)")
      end

      it "prepends plus sign when number_sign is :plus" do
        Plurimath.configuration.number_formatter = plus_hex_formatter

        expect(described_class.new("255").to_unicodemath(options: {})).to eq("+ff_(16)")
      end

      it "returns plain string for base 10" do
        Plurimath.configuration.number_formatter = Plurimath::Formatter::Standard.new

        expect(described_class.new("42").to_unicodemath(options: {})).to eq("42")
      end
    end

    describe "to_omml_without_math_tag" do
      it "produces sSub structure for base 16" do
        Plurimath.configuration.number_formatter = hex_formatter
        result = described_class.new("255").to_omml_without_math_tag(true,
                                                                     options: {})
        xml = Plurimath.xml_engine.dump(result.first, indent: 2)

        expect(xml).to be_xml_equivalent_to(
          "<m:sSub><m:sSubPr><m:ctrlPr><w:rPr><w:rFonts w:ascii=\"Cambria Math\" w:hAnsi=\"Cambria Math\"/><w:i/></w:rPr></m:ctrlPr></m:sSubPr>" \
          "<m:e><m:r><m:t>ff</m:t></m:r></m:e>" \
          "<m:sub><m:r><m:t>16</m:t></m:r></m:sub></m:sSub>",
        )
      end

      it "includes sign inside e element for negative numbers" do
        Plurimath.configuration.number_formatter = hex_formatter
        result = described_class.new("-255").to_omml_without_math_tag(true,
                                                                      options: {})
        xml = Plurimath.xml_engine.dump(result.first, indent: 2)

        expect(xml).to be_xml_equivalent_to(
          "<m:sSub><m:sSubPr><m:ctrlPr><w:rPr><w:rFonts w:ascii=\"Cambria Math\" w:hAnsi=\"Cambria Math\"/><w:i/></w:rPr></m:ctrlPr></m:sSubPr>" \
          "<m:e><m:r><m:t>-ff</m:t></m:r></m:e>" \
          "<m:sub><m:r><m:t>16</m:t></m:r></m:sub></m:sSub>",
        )
      end

      it "includes plus sign inside e element for number_sign :plus" do
        Plurimath.configuration.number_formatter = plus_hex_formatter
        result = described_class.new("255").to_omml_without_math_tag(true,
                                                                     options: {})
        xml = Plurimath.xml_engine.dump(result.first, indent: 2)

        expect(xml).to be_xml_equivalent_to(
          "<m:sSub><m:sSubPr><m:ctrlPr><w:rPr><w:rFonts w:ascii=\"Cambria Math\" w:hAnsi=\"Cambria Math\"/><w:i/></w:rPr></m:ctrlPr></m:sSubPr>" \
          "<m:e><m:r><m:t>+ff</m:t></m:r></m:e>" \
          "<m:sub><m:r><m:t>16</m:t></m:r></m:sub></m:sSub>",
        )
      end

      it "falls back to m:t for base 10" do
        Plurimath.configuration.number_formatter = Plurimath::Formatter::Standard.new
        result = described_class.new("42").to_omml_without_math_tag(true,
                                                                    options: {})
        xml = Plurimath.xml_engine.dump(result.first, indent: 2)

        expect(xml).to be_xml_equivalent_to("<m:t>42</m:t>")
      end
    end
  end

  describe "stored base attribute" do
    around do |example|
      previous_formatter = Plurimath.configuration.number_formatter
      example.run
    ensure
      Plurimath.configuration.number_formatter = previous_formatter
    end

    it "uses stored base for formatting when no explicit base option provided" do
      Plurimath.configuration.number_formatter = Plurimath::Formatter::Standard.new
      number = described_class.new("255", base: 16)

      expect(number.to_asciimath(options: {})).to eq("ff_(16)")
    end

    it "stored base takes precedence over formatter built-in base" do
      Plurimath.configuration.number_formatter = Plurimath::Formatter::Standard.new(options: { base: 8 })
      number = described_class.new("255", base: 16)

      # stored base (16) is the semantic truth about the number
      expect(number.to_asciimath(options: {})).to eq("ff_(16)")
    end
  end
end
