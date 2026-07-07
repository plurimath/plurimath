require "spec_helper"

# Characterization specs (refactor phase A0) for the OMML-side token-resolution
# class method. These pin CURRENT behavior on main — including known bugs, each
# marked with a "# quirk:" comment — ahead of a strictly behavior-preserving
# refactor. Do not "fix" an expectation here; behavior changes belong in a
# later, separate PR together with the production-code change.
RSpec.describe Plurimath::Omml::Utility do
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

    # quirk: Formula#extract_class_name_from_text returns nil when the
    # single value is not a Function::Text, and valid_class calls
    # nil.to_sym — raising NoMethodError instead of returning false.
    it "raises NoMethodError for a Formula wrapping a non-Text value" do
      formula = Plurimath::Math::Formula.new([Plurimath::Math::Number.new("3")])

      expect { described_class.valid_class(formula) }.to raise_error(NoMethodError)
    end

    # quirk: FontStyle#extract_class_name_from_text always returns
    # parameter_one.class_name ("text" for Text params — its first line is a
    # no-op), so even FontStyle(Text("lim")) is not a valid class.
    it "returns false for a FontStyle wrapping Text(\"lim\")" do
      font_style = Plurimath::Math::Function::FontStyle.new(
        Plurimath::Math::Function::Text.new("lim"), "mathrm"
      )

      expect(described_class.valid_class(font_style)).to be(false)
    end
  end
end
