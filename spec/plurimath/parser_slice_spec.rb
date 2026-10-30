# frozen_string_literal: true

require "spec_helper"

RSpec.describe Plurimath::Utility do
  {
    parslet: ->(text) { Parslet::Source.new(text).consume(text.length) },
    parsanol: ->(text) { Parsanol::Slice.new(0, text, text) },
  }.each do |backend, build_slice|
    context "with a #{backend} slice" do
      it "retains the Number's string value and base" do
        number = Plurimath::Math::Number.new(build_slice.call("FF"), base: 16)

        expect(number.value).to be_an_instance_of(String)
        expect(number.value).to eq("FF")
        expect(number.base).to eq(16)
      end

      it "stores Text content as a String for rendering" do
        text = Plurimath::Math::Function::Text.new(build_slice.call("hello"))

        expect(text.parameter_one).to be_an_instance_of(String)
        expect(text.to_asciimath).to eq('"hello"')
      end

      it "constructs the same symbol as a String input" do
        actual = described_class.symbols_class(build_slice.call("x"), lang: :latex)

        expect(actual).to eq(described_class.symbols_class("x", lang: :latex))
      end
    end
  end
end
