require "spec_helper"

# Characterization specs (refactor phase A0) for the OMML-side token-resolution
# class method. These pin CURRENT behavior on main — including known bugs, each
# marked with a "# quirk:" comment — ahead of a strictly behavior-preserving
# refactor. Do not "fix" an expectation here; behavior changes belong in a
# later, separate PR together with the production-code change.
RSpec.describe Plurimath::Omml::Utility do
  def parse_omml(body)
    Plurimath::Omml::Parser.new(<<~OMML).parse
      <m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math">
        <m:oMath>#{body}</m:oMath>
      </m:oMathPara>
    OMML
  end

  describe ".valid_class" do
    # Realistic OMML input: script_class_for(base) receives a Formula
    # wrapping a single Function::Text (from omml_argument_value).
    it "returns true for a Formula wrapping Text(\"lim\") (latex :power_base)" do
      formula = Plurimath::Math::Formula.new([Plurimath::Math::Function::Text.new("lim")])

      expect(described_class.valid_class(formula)).to be(true)
    end

    it "returns true for a Formula wrapping Text(\"log\")" do
      formula = Plurimath::Math::Formula.new([Plurimath::Math::Function::Text.new("log")])

      expect(described_class.valid_class(formula)).to be(true)
    end

    it "returns false for a Formula wrapping Text(\"sum\") (latex :ternary, not :power_base)" do
      formula = Plurimath::Math::Formula.new([Plurimath::Math::Function::Text.new("sum")])

      expect(described_class.valid_class(formula)).to be(false)
    end

    it "returns false for a Formula wrapping Text with a non-function word" do
      formula = Plurimath::Math::Formula.new([Plurimath::Math::Function::Text.new("hello")])

      expect(described_class.valid_class(formula)).to be(false)
    end

    it "returns false for a bare Text (core extract_class_name_from_text is \"\")" do
      expect(described_class.valid_class(Plurimath::Math::Function::Text.new("lim")))
        .to be(false)
    end

    it "returns false for a bare Number" do
      expect(described_class.valid_class(Plurimath::Math::Number.new("3")))
        .to be(false)
    end

    it "returns false for a Formula wrapping a non-Text value" do
      formula = Plurimath::Math::Formula.new([Plurimath::Math::Number.new("3")])

      expect(described_class.valid_class(formula)).to be(false)
    end

    # FontStyle#extract_class_name_from_text now returns the wrapped text, so a
    # font-styled function word validates just like a bare one.
    it "returns true for a FontStyle wrapping Text(\"lim\")" do
      font_style = Plurimath::Math::Function::FontStyle.new(
        Plurimath::Math::Function::Text.new("lim"), "mathrm"
      )

      expect(described_class.valid_class(font_style)).to be(true)
    end

    # The non-Text branch still falls back to the class name.
    it "returns false for a FontStyle wrapping a non-Text value" do
      font_style = Plurimath::Math::Function::FontStyle.new(
        Plurimath::Math::Number.new("3"), "mathrm"
      )

      expect(described_class.valid_class(font_style)).to be(false)
    end
  end

  describe ".resolve_text_token" do
    it "resolves representation-free named function words" do
      aggregate_failures do
        expect(described_class.resolve_text_token("sin"))
          .to eq(Plurimath::Math::Function::Sin.new)
        expect(described_class.resolve_text_token("min"))
          .to eq(Plurimath::Math::Function::Min.new)
        expect(described_class.resolve_text_token("mod"))
          .to eq(Plurimath::Math::Function::Mod.new)
      end
    end

    it "keeps structurally represented words as literal text" do
      aggregate_failures do
        expect(described_class.resolve_text_token("frac"))
          .to eq(Plurimath::Math::Function::Text.new("frac", lang: :omml))
        expect(described_class.resolve_text_token("sqrt"))
          .to eq(Plurimath::Math::Function::Text.new("sqrt", lang: :omml))
        expect(described_class.resolve_text_token("sum"))
          .to eq(Plurimath::Math::Function::Text.new("sum", lang: :omml))
        expect(described_class.resolve_text_token("bar"))
          .to eq(Plurimath::Math::Function::Text.new("bar", lang: :omml))
      end
    end

    it "wraps unknown words in Function::Text" do
      expect(described_class.resolve_text_token("hello"))
        .to eq(Plurimath::Math::Function::Text.new("hello", lang: :omml))
    end

    it "wraps digits in Math::Number" do
      expect(described_class.resolve_text_token("123"))
        .to eq(Plurimath::Math::Number.new("123"))
    end

    it "resolves non-word operators through symbols" do
      expect(described_class.resolve_text_token("+"))
        .to eq(Plurimath::Math::Symbols::Plus.new)
    end

    it "falls back to a generic Symbol for entity-normalized characters" do
      expect(described_class.resolve_text_token("<"))
        .to eq(Plurimath::Math::Symbols::Symbol.new("<"))
    end
  end

  describe ".resolve_symbol_token" do
    it "resolves unicode function characters to function instances" do
      aggregate_failures do
        expect(described_class.resolve_symbol_token("∑"))
          .to eq(Plurimath::Math::Function::Sum.new)
        expect(described_class.resolve_symbol_token("¯"))
          .to eq(Plurimath::Math::Function::Bar.new)
      end
    end

    it "resolves representation-free named function words" do
      aggregate_failures do
        expect(described_class.resolve_symbol_token("sin"))
          .to eq(Plurimath::Math::Function::Sin.new)
        expect(described_class.resolve_symbol_token("mod"))
          .to eq(Plurimath::Math::Function::Mod.new)
      end
    end

    it "keeps structurally represented words as literal symbols" do
      aggregate_failures do
        expect(described_class.resolve_symbol_token("frac"))
          .to eq(Plurimath::Math::Symbols::Symbol.new("frac"))
        expect(described_class.resolve_symbol_token("sqrt"))
          .to eq(Plurimath::Math::Symbols::Symbol.new("sqrt"))
        expect(described_class.resolve_symbol_token("sum"))
          .to eq(Plurimath::Math::Symbols::Symbol.new("sum"))
        expect(described_class.resolve_symbol_token("bar"))
          .to eq(Plurimath::Math::Symbols::Symbol.new("bar"))
      end
    end

    it "keeps digits on the symbol fallback path" do
      expect(described_class.resolve_symbol_token("123"))
        .to eq(Plurimath::Math::Symbols::Symbol.new("123"))
    end
  end

  describe "parser integration" do
    it "keeps structurally represented text-run words literal" do
      expected = Plurimath::Math::Formula.new(
        [Plurimath::Math::Function::Text.new("frac", lang: :omml)],
      )

      expect(parse_omml("<m:r><m:t>frac</m:t></m:r>"))
        .to eq(expected)
    end

    it "uses the OMML mrow resolver for function names" do
      formula = parse_omml(<<~OMML)
        <m:func>
          <m:fName><m:r><m:t>sin</m:t></m:r></m:fName>
          <m:e><m:r><m:t>x</m:t></m:r></m:e>
        </m:func>
      OMML

      expected = Plurimath::Math::Formula.new(
        [
          Plurimath::Math::Function::Sin.new(
            Plurimath::Math::Function::Text.new("x", lang: :omml),
          ),
        ],
      )
      expect(formula).to eq(expected)
    end

    it "uses the OMML symbol resolver for n-ary characters" do
      formula = parse_omml(<<~OMML)
        <m:nary>
          <m:naryPr>
            <m:chr m:val="∑"/>
            <m:limLoc m:val="subSup"/>
          </m:naryPr>
          <m:sub><m:r><m:t>1</m:t></m:r></m:sub>
          <m:sup><m:r><m:t>n</m:t></m:r></m:sup>
          <m:e><m:r><m:t>x</m:t></m:r></m:e>
        </m:nary>
      OMML

      expected = Plurimath::Math::Formula.new(
        [
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Number.new("1"),
            Plurimath::Math::Function::Text.new("n", lang: :omml),
            Plurimath::Math::Function::Text.new("x", lang: :omml),
          ),
        ],
      )
      expect(formula).to eq(expected)
    end

    it "uses the OMML symbol resolver for accent characters" do
      formula = parse_omml(<<~OMML)
        <m:acc>
          <m:accPr><m:chr m:val="¯"/></m:accPr>
          <m:e><m:r><m:t>x</m:t></m:r></m:e>
        </m:acc>
      OMML

      expected = Plurimath::Math::Formula.new(
        [
          Plurimath::Math::Function::Bar.new(
            Plurimath::Math::Function::Text.new("x", lang: :omml),
            { accent: true },
          ),
        ],
      )
      expect(formula).to eq(expected)
    end
  end

  describe ".populate_function_classes" do
    it "resolves a leading function-name String and gives it the next element" do
      result = described_class.populate_function_classes(
        ["sin", Plurimath::Math::Number.new("2")],
      )

      expect(result).to eq(
        [Plurimath::Math::Function::Sin.new(Plurimath::Math::Number.new("2"))],
      )
    end

    it "resolves an unknown word String to Symbols::Symbol, not Function::Text" do
      result = described_class.populate_function_classes(
        ["hello", Plurimath::Math::Number.new("2")],
      )

      expect(result).to eq(
        [
          Plurimath::Math::Symbols::Symbol.new("hello"),
          Plurimath::Math::Number.new("2"),
        ],
      )
    end

    it "resolves a digits-only String to Symbols::Symbol, not Math::Number" do
      result = described_class.populate_function_classes(["123"])

      expect(result).to eq([Plurimath::Math::Symbols::Symbol.new("123")])
    end

    it "keeps a \"bar\" String a literal Symbol, not consuming the next element" do
      result = described_class.populate_function_classes(
        ["bar", Plurimath::Math::Number.new("2")],
      )

      expect(result).to eq(
        [
          Plurimath::Math::Symbols::Symbol.new("bar"),
          Plurimath::Math::Number.new("2"),
        ],
      )
    end

    it "keeps a \"frac\" String a literal Symbol, leaving trailing arguments" do
      result = described_class.populate_function_classes(
        ["frac", Plurimath::Math::Number.new("1"), Plurimath::Math::Number.new("2")],
      )

      expect(result).to eq(
        [
          Plurimath::Math::Symbols::Symbol.new("frac"),
          Plurimath::Math::Number.new("1"),
          Plurimath::Math::Number.new("2"),
        ],
      )
    end

    it "slots both operands around a \"mod\" String" do
      result = described_class.populate_function_classes(
        [Plurimath::Math::Number.new("1"), "mod", Plurimath::Math::Number.new("2")],
      )

      expect(result).to eq(
        [
          Plurimath::Math::Function::Mod.new(
            Plurimath::Math::Number.new("1"),
            Plurimath::Math::Number.new("2"),
          ),
        ],
      )
    end

    it "drops a leading Mod from the mrow" do
      result = described_class.populate_function_classes(
        ["mod", Plurimath::Math::Number.new("1"), Plurimath::Math::Number.new("2")],
      )

      expect(result).to eq(
        [Plurimath::Math::Number.new("1"), Plurimath::Math::Number.new("2")],
      )
    end

    it "fills parameter_three of a partially-filled ternary from the next element" do
      ternary = Plurimath::Math::Function::Underover.new(
        Plurimath::Math::Symbols::Sum.new,
        Plurimath::Math::Number.new("1"),
        nil,
      )

      result = described_class.populate_function_classes(
        [ternary, Plurimath::Math::Number.new("9")],
      )

      expect(result).to eq(
        [
          Plurimath::Math::Function::Underover.new(
            Plurimath::Math::Symbols::Sum.new,
            Plurimath::Math::Number.new("1"),
            Plurimath::Math::Number.new("9"),
          ),
        ],
      )
    end

    it "flattens nested arrays and compacts nils before processing" do
      result = described_class.populate_function_classes(
        [["sin"], nil, [Plurimath::Math::Number.new("2")]],
      )

      expect(result).to eq(
        [Plurimath::Math::Function::Sin.new(Plurimath::Math::Number.new("2"))],
      )
    end

    it "returns [] for an empty mrow" do
      expect(described_class.populate_function_classes([])).to eq([])
    end

    it "passes non-String, non-function elements through untouched" do
      formula = Plurimath::Math::Formula.new([Plurimath::Math::Function::Text.new("sin")])
      argument = Plurimath::Math::Number.new("2")

      result = described_class.populate_function_classes([formula, argument])

      expect(result[0]).to be(formula)
      expect(result[1]).to be(argument)
    end

    it "only lets a unary function at index 0 consume the following element" do
      result = described_class.populate_function_classes(
        [
          Plurimath::Math::Number.new("3"),
          "sin",
          Plurimath::Math::Number.new("2"),
        ],
      )

      expect(result).to eq(
        [
          Plurimath::Math::Number.new("3"),
          Plurimath::Math::Function::Sin.new,
          Plurimath::Math::Number.new("2"),
        ],
      )
    end

    it "fills an already-instantiated empty unary function at index 0" do
      result = described_class.populate_function_classes(
        [Plurimath::Math::Function::Sin.new, Plurimath::Math::Number.new("2")],
      )

      expect(result).to eq(
        [Plurimath::Math::Function::Sin.new(Plurimath::Math::Number.new("2"))],
      )
    end
  end
end
