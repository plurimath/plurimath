require "spec_helper"

RSpec.describe Plurimath::Math do
  describe ".initialize" do
    subject(:formula) { Plurimath::Math.parse(input, type) }

    context "contains incorrect type with parseable input of asciimath" do
      let(:input) { "sin(d)" }
      let(:type) { "wrong_type" }

      it "raises error on wrong type" do
        expect{formula}.to raise_error(Plurimath::Math::InvalidTypeError)
      end
    end

    context "contains correct type with incomplete input of latex" do
      let(:input) { '{\sin{d}' }
      let(:type) { "latex" }

      it "raises error on wrong text input" do
        message = "Failed to parse the following formula with type `#{type}`"
        expect{formula}.to raise_error(
          Plurimath::Math::ParseError, Regexp.compile(message)
        )
      end
    end

    context "contains correct input string and custom invalid formula" do

      it "raises error on wrong text input" do
        formula = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sin.new("d"),
        ])
        expect{formula.to_html}.to raise_error(Plurimath::Math::ParseError)
        expect{formula.to_omml}.to raise_error(Plurimath::Math::ParseError)
        expect{formula.to_latex}.to raise_error(Plurimath::Math::ParseError)
        expect{formula.to_mathml}.to raise_error(Plurimath::Math::ParseError)
        expect{formula.to_asciimath}.to raise_error(Plurimath::Math::ParseError)
        expect{formula.to_unicodemath}.to raise_error(Plurimath::Math::ParseError)
      end
    end

    context "preserves specialized error types from lower layers" do
      let(:input) { "mm^(b)" }
      let(:type) { "unitsml" }

      it "raises error with specialized unitsml error message" do
        message = "The use of a variable as an exponent is not valid."
        expect{formula}.to raise_error(
          Plurimath::Math::ParseError, Regexp.compile(message)
        )
      end
    end
  end

  describe ".parse with cache option" do
    before { Plurimath::Math::FORMULA_CACHE.clear }

    let(:input) { "x + y" }
    let(:type) { :asciimath }

    context "contains cache option set to false (default)" do
      it "returns independent formula objects for same input" do
        f1 = Plurimath::Math.parse(input, type)
        f2 = Plurimath::Math.parse(input, type)
        expect(f1).not_to equal(f2)
        expect(f1).to eq(f2)
      end

      it "does not populate the formula cache" do
        Plurimath::Math.parse(input, type)
        expect(Plurimath::Math::FORMULA_CACHE[type]).to be_empty
      end
    end

    context "contains cache option set to true" do
      it "returns independent formula objects for same input" do
        f1 = Plurimath::Math.parse(input, type, cache: true)
        f2 = Plurimath::Math.parse(input, type, cache: true)
        expect(f1).not_to equal(f2)
        expect(f1).to eq(f2)
      end

      it "populates the formula cache" do
        Plurimath::Math.parse(input, type, cache: true)
        expect(Plurimath::Math::FORMULA_CACHE[type]).not_to be_empty
      end

      it "protects cache from mutation by first caller" do
        f1 = Plurimath::Math.parse("a^2", :latex, cache: true)
        f1.value.clear
        f2 = Plurimath::Math.parse("a^2", :latex, cache: true)
        expect(f2.value).not_to be_empty
      end

      it "protects cache from mutation by cache-hit caller" do
        Plurimath::Math.parse("a^2", :latex, cache: true)
        f2 = Plurimath::Math.parse("a^2", :latex, cache: true)
        f2.value.clear
        f3 = Plurimath::Math.parse("a^2", :latex, cache: true)
        expect(f3.value).not_to be_empty
      end
    end
  end

  describe ".clear_cache!" do
    before { Plurimath::Math::FORMULA_CACHE.clear }

    it "empties the formula cache" do
      Plurimath::Math.parse("x + y", :asciimath, cache: true)
      expect(Plurimath::Math::FORMULA_CACHE).not_to be_empty

      Plurimath::Math.clear_cache!
      expect(Plurimath::Math::FORMULA_CACHE).to be_empty
    end

    it "forces re-parsing after cache is cleared" do
      f1 = Plurimath::Math.parse("a^2", :latex, cache: true)
      Plurimath::Math.clear_cache!
      f2 = Plurimath::Math.parse("a^2", :latex, cache: true)
      expect(f1).not_to equal(f2)
      expect(f1).to eq(f2)
    end
  end
end
