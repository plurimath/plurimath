require "spec_helper"

# The reader faults that docs/unicodemath.adoc used to record as known.
RSpec.describe "UnicodeMath reader" do
  def read(text)
    Plurimath::Math.parse(text, :unicode)
  end

  describe "\\u escapes" do
    it "reads an escape with leading zeros as the character" do
      expect(read("\\u03B1+1").to_latex).to eq("\\alpha + 1")
    end

    it "reads an escape without leading zeros as before" do
      expect(read("\\u3b1+1").to_latex).to eq("\\alpha + 1")
    end

    it "keeps the characters that follow the escape" do
      expect(read("\\u03B1x+1").to_latex).to eq("\\alpha x + 1")
    end
  end

  describe "a leading negative value after an intent marker" do
    it "reads the marker and the value" do
      formula = read('ⓘ("m"-1)')
      expect(formula.value.first).to be_a(Plurimath::Math::Function::Intent)
      expect(formula.value.first.parameter_two.parameter_one).to eq("m")
    end

    it "keeps the negative value" do
      expect(read('ⓘ("m"-1)').to_asciimath).to eq(%(intent(- 1)("m")))
    end
  end

  describe "a matrix with a bracket on one side" do
    it "is written back with the matrix and the invisible close" do
      expect(read("{■(a&b)┤").to_unicodemath).to eq("{■(a&b)┤")
    end

    it "is not written as the matrix character Ⓢ" do
      expect(read("{■(a&b)┤").to_unicodemath).not_to include("Ⓢ")
    end

    it "still writes a matrix with both brackets as its matrix character" do
      expect(read("{■(a&b)}").to_unicodemath).to eq("Ⓢ(a&b)")
    end
  end

  describe "the stack a¦b" do
    it "is a fraction without a bar" do
      fraction = read("a¦b").value.first
      expect(fraction).to be_a(Plurimath::Math::Function::Frac)
      expect(fraction.options).to eq(linethickness: "0")
    end

    it "keeps the missing bar in MathML and in UnicodeMath" do
      formula = read("a¦b")
      expect(formula.to_mathml).to include('<mfrac linethickness="0">')
      expect(formula.to_unicodemath).to eq("(a)¦(b)")
    end
  end

  describe "a math alphanumeric letter" do
    it "stays the character, as UTN 28 encodes it" do
      expect(read("𝐱").value.first.value).to eq("&#x1d431;")
    end
  end
end
