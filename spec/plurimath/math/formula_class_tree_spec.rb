require "spec_helper"

RSpec.describe Plurimath::Math::Formula, "class tree" do
  describe "#to_display(:formula)" do
    it "shows the concrete stored wrappers in the README example" do
      formula = Plurimath::Math.parse("sin(1)", :asciimath)

      expect(formula.to_display(:formula)).to eq(<<~TREE.chomp)
        Plurimath::Math::Formula
          value[0]: Plurimath::Math::Function::Sin
            parameter_one: Plurimath::Math::Function::Fenced
              parameter_one: Plurimath::Math::Symbols::Paren::Lround
                value: nil
              parameter_two[0]: Plurimath::Math::Number
                value: "1"
              parameter_three: Plurimath::Math::Symbols::Paren::Rround
                value: nil
      TREE
    end

    it "renders the original underbrace expression from plurimath#310" do
      formula = Plurimath::Math.parse('ubrace(1+2+3+4)_("4 terms")', :asciimath)

      expect(formula.to_display(:formula)).to eq(<<~TREE.chomp)
        Plurimath::Math::Formula
          value[0]: Plurimath::Math::Function::Base
            parameter_one: Plurimath::Math::Function::Ubrace
              parameter_one: Plurimath::Math::Formula
                value[0]: Plurimath::Math::Number
                  value: "1"
                value[1]: Plurimath::Math::Symbols::Plus
                  value: nil
                value[2]: Plurimath::Math::Number
                  value: "2"
                value[3]: Plurimath::Math::Symbols::Plus
                  value: nil
                value[4]: Plurimath::Math::Number
                  value: "3"
                value[5]: Plurimath::Math::Symbols::Plus
                  value: nil
                value[6]: Plurimath::Math::Number
                  value: "4"
            parameter_two: Plurimath::Math::Function::Text
              parameter_one: "4 terms"
      TREE
    end

    it "keeps flat operators as stored siblings" do
      formula = Plurimath::Math.parse("a+b", :asciimath)

      expect(formula.to_display(:formula)).to eq(<<~TREE.chomp)
        Plurimath::Math::Formula
          value[0]: Plurimath::Math::Symbols::Symbol
            value: "a"
          value[1]: Plurimath::Math::Symbols::Plus
            value: nil
          value[2]: Plurimath::Math::Symbols::Symbol
            value: "b"
      TREE
    end

    it "keeps fraction and integral parameters in order, including absent operands" do
      fraction = Plurimath::Math::Function::Frac.new(
        Plurimath::Math::Number.new("1"),
        described_class.new([Plurimath::Math::Number.new("2")]),
      )
      integral = Plurimath::Math::Function::Int.new(nil, nil, fraction)

      expect(described_class.new([integral]).to_display(:formula)).to eq(<<~TREE.chomp)
        Plurimath::Math::Formula
          value[0]: Plurimath::Math::Function::Int
            parameter_one: nil
            parameter_two: nil
            parameter_three: Plurimath::Math::Function::Frac
              parameter_one: Plurimath::Math::Number
                value: "1"
              parameter_two: Plurimath::Math::Formula
                value[0]: Plurimath::Math::Number
                  value: "2"
      TREE
    end

    it "includes all four nary fields and preserves script nodes" do
      script = Plurimath::Math::Function::Power.new(
        Plurimath::Math::Function::Base.new(Plurimath::Math::Symbols::Symbol.new("x"), nil),
        Plurimath::Math::Number.new("2"),
      )
      nary = Plurimath::Math::Function::Nary.new(nil, nil, nil, script)

      expect(described_class.new([nary]).to_display(:formula)).to eq(<<~TREE.chomp)
        Plurimath::Math::Formula
          value[0]: Plurimath::Math::Function::Nary
            parameter_one: nil
            parameter_two: nil
            parameter_three: nil
            parameter_four: Plurimath::Math::Function::Power
              parameter_one: Plurimath::Math::Function::Base
                parameter_one: Plurimath::Math::Symbols::Symbol
                  value: "x"
                parameter_two: nil
              parameter_two: Plurimath::Math::Number
                value: "2"
      TREE
    end

    it "distinguishes empty arrays, absent children and absent leaf values" do
      formula = described_class.new([
        described_class.new,
        Plurimath::Math::Function::Sin.new,
        Plurimath::Math::Number.new,
        nil,
      ])

      expect(formula.to_display(:formula)).to eq(<<~TREE.chomp)
        Plurimath::Math::Formula
          value[0]: Plurimath::Math::Formula
            value: []
          value[1]: Plurimath::Math::Function::Sin
            parameter_one: nil
          value[2]: Plurimath::Math::Number
            value: nil
          value[3]: nil
      TREE
    end

    it "accepts the same symbol and string type spellings as type validation" do
      formula = described_class.new
      expected = "Plurimath::Math::Formula\n  value: []"

      [:formula, :FORMULA, "formula", "FORMULA"].each do |type|
        expect(formula.to_display(type)).to eq(expected)
      end
    end

    it "shows concrete Formula subclasses and indexes nested arrays" do
      formula = described_class.new([
        described_class::Mrow.new([[Plurimath::Math::Number.new("1")], []]),
      ])

      expect(formula.to_display(:formula)).to eq(<<~TREE.chomp)
        Plurimath::Math::Formula
          value[0]: Plurimath::Math::Formula::Mrow
            value[0][0]: Plurimath::Math::Number
              value: "1"
            value[1]: []
      TREE
    end

    it "preserves table, row and cell order and stored delimiters" do
      table = Plurimath::Math::Function::Table.new([
        Plurimath::Math::Function::Tr.new([
          Plurimath::Math::Function::Td.new([Plurimath::Math::Number.new("1")]),
          Plurimath::Math::Function::Td.new([]),
        ]),
        Plurimath::Math::Function::Tr.new([]),
      ])

      expect(described_class.new([table]).to_display(:formula)).to eq(<<~TREE.chomp)
        Plurimath::Math::Formula
          value[0]: Plurimath::Math::Function::Table
            value[0]: Plurimath::Math::Function::Tr
              parameter_one[0]: Plurimath::Math::Function::Td
                parameter_one[0]: Plurimath::Math::Number
                  value: "1"
                parameter_two: nil
              parameter_one[1]: Plurimath::Math::Function::Td
                parameter_one: []
                parameter_two: nil
            value[1]: Plurimath::Math::Function::Tr
              parameter_one: []
            open_paren: nil
            close_paren: nil
      TREE
    end

    it "escapes literals without losing Unicode or creating extra tree lines" do
      text = Plurimath::Math::Function::Text.new("α \"quoted\" \\path\n\tline")
      formula = described_class.new([text, Plurimath::Math::Symbols::Symbol.new("β")])

      expect(formula.to_display(:formula)).to eq(<<~'TREE'.chomp)
        Plurimath::Math::Formula
          value[0]: Plurimath::Math::Function::Text
            parameter_one: "α \"quoted\" \\path\n\tline"
          value[1]: Plurimath::Math::Symbols::Symbol
            value: "β"
      TREE
    end

    it "renders repeated references fully and leaves the model and options unchanged" do
      number = Plurimath::Math::Number.new("1")
      fraction = Plurimath::Math::Function::Frac.new(number, number, { bevelled: true })
      formula = described_class.new([fraction])
      before = Marshal.dump(formula)
      expected = <<~TREE.chomp
        Plurimath::Math::Formula
          value[0]: Plurimath::Math::Function::Frac
            parameter_one: Plurimath::Math::Number
              value: "1"
            parameter_two: Plurimath::Math::Number
              value: "1"
      TREE

      2.times { expect(formula.to_display(:formula)).to eq(expected) }
      expect(Marshal.dump(formula)).to eq(before)
      expect(fraction.parameter_one).to equal(number)
      expect(fraction.parameter_two).to equal(number)
    end

    it "marks an ancestor cycle without treating a shared child as a cycle" do
      formula = described_class.new
      formula.value << formula

      expect(formula.to_display(:formula)).to eq(<<~TREE.chomp)
        Plurimath::Math::Formula
          value[0]: <cycle: Plurimath::Math::Formula>
      TREE
    end

    it "includes the declared uncertainty fields rather than just its value" do
      uncertainty = Plurimath::Math::Function::Uncertainty.new(
        Plurimath::Math::Number.new("1.230"), category: :standard,
        magnitude: Plurimath::Math::Number.new("0.004"),
      )

      expect(described_class.new([uncertainty]).to_display(:formula)).to eq(<<~TREE.chomp)
        Plurimath::Math::Formula
          value[0]: Plurimath::Math::Function::Uncertainty
            value: Plurimath::Math::Number
              value: "1.230"
            category: :standard
            magnitude: Plurimath::Math::Number
              value: "0.004"
            coverage_factor: nil
            coverage_probability: nil
            lower: nil
            upper: nil
            interval_kind: nil
            notation: :absolute
            unit: nil
      TREE
    end

    it "shows UnitsML source content without traversing its parsed internals" do
      units = Plurimath::Math::Function::Unitsml.new("m")

      expect(described_class.new([units]).to_display(:formula)).to eq(<<~TREE.chomp)
        Plurimath::Math::Formula
          value[0]: Plurimath::Math::Function::Unitsml
            text: "m"
      TREE
    end
  end
end
