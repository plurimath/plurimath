# frozen_string_literal: true

require "spec_helper"

RSpec.describe Plurimath::Formatter::Numbers::PartsRenderer do
  let(:symbols) do
    {
      decimal: ".",
      group: ",",
      group_digits: 3,
      fraction_group: " ",
      fraction_group_digits: 3,
    }
  end
  let(:options) { Plurimath::Formatter::Numbers::FormatOptions.new(symbols: symbols) }
  let(:integer_formatter) { Plurimath::Formatter::Numbers::Integer.new(options) }
  let(:fraction_formatter) { Plurimath::Formatter::Numbers::Fraction.new(options) }
  let(:renderer) do
    described_class.new(
      integer_formatter: integer_formatter,
      fraction_formatter: fraction_formatter,
    )
  end

  describe "#render" do
    it "renders grouped integer and fraction parts" do
      parts = Plurimath::Formatter::Numbers::Parts.new(
        sign: 1,
        base: 10,
        integer_digits: "1234",
        fraction_digits: "5678",
      )

      expect(renderer.render(parts)).to eq("1,234.567 8")
    end

    it "omits the decimal separator when there are no fraction digits" do
      parts = Plurimath::Formatter::Numbers::Parts.new(
        sign: 1,
        base: 10,
        integer_digits: "1234",
        fraction_digits: "",
      )

      expect(renderer.render(parts)).to eq("1,234")
    end
  end
end
