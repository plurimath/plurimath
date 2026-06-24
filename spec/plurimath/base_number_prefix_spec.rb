# frozen_string_literal: true

require "spec_helper"

RSpec.describe Plurimath::BaseNumberPrefix do
  describe "Parser module" do
    let(:parser_class) do
      Class.new(Parslet::Parser) do
        include Plurimath::BaseNumberPrefix::Parser

        rule(:base_prefixed_number) do
          hex_number | binary_number | octal_number
        end

        root(:base_prefixed_number)
      end
    end

    it "parses hex literals" do
      tree = parser_class.new.parse("0xFF")
      expect(tree[:hex_number].to_s).to eq("FF")
    end

    it "parses uppercase hex prefix" do
      tree = parser_class.new.parse("0XAB")
      expect(tree[:hex_number].to_s).to eq("AB")
    end

    it "parses binary literals" do
      tree = parser_class.new.parse("0b1010")
      expect(tree[:binary_number].to_s).to eq("1010")
    end

    it "parses uppercase binary prefix" do
      tree = parser_class.new.parse("0B111")
      expect(tree[:binary_number].to_s).to eq("111")
    end

    it "parses octal literals" do
      tree = parser_class.new.parse("0o17")
      expect(tree[:octal_number].to_s).to eq("17")
    end

    it "parses uppercase octal prefix" do
      tree = parser_class.new.parse("0O77")
      expect(tree[:octal_number].to_s).to eq("77")
    end

    it "requires at least one digit after prefix" do
      expect { parser_class.new.parse("0x") }.to raise_error(Parslet::ParseFailed)
    end
  end

  describe "Transform module" do
    let(:transform_class) do
      Class.new(Parslet::Transform) do
        include Plurimath::BaseNumberPrefix::Transform
      end
    end

    it "builds Number with base 16 from hex" do
      result = transform_class.new.apply(hex_number: "FF")
      expect(result).to be_a(Plurimath::Math::Number)
      expect(result.value).to eq("FF")
      expect(result.base).to eq(16)
    end

    it "builds Number with base 2 from binary, storing decimal value" do
      result = transform_class.new.apply(binary_number: "1010")
      expect(result).to be_a(Plurimath::Math::Number)
      expect(result.value).to eq("10")
      expect(result.base).to eq(2)
    end

    it "builds Number with base 8 from octal, storing decimal value" do
      result = transform_class.new.apply(octal_number: "17")
      expect(result).to be_a(Plurimath::Math::Number)
      expect(result.value).to eq("15")
      expect(result.base).to eq(8)
    end
  end

  describe "integration with real parsers" do
    [
      %i[asciimath asciimath],
      %i[latex latex],
      %i[unicode unicodemath],
      %i[html html],
    ].each do |type, name|
      context "via #{name} parser" do
        it "parses 0xFF with base 16" do
          number = Plurimath::Math.parse("0xFF", type).value.first
          expect(number).to be_a(Plurimath::Math::Number)
          expect(number.base).to eq(16)
        end
      end
    end
  end
end
