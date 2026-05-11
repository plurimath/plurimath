# frozen_string_literal: true

require "spec_helper"

RSpec.describe Plurimath::Formatter::Numbers::SymbolResolver do
  describe "#resolve" do
    it "merges locale defaults and overrides without mutating locale data" do
      locale_symbols = Plurimath::Formatter::SupportedLocales::LOCALES[:en]
      resolver = described_class.new(
        :en,
        localizer_symbols: { decimal: "@" },
        localize_number: nil,
      )

      resolved = resolver.resolve

      expect(resolved[:decimal]).to eq("@")
      expect(locale_symbols[:decimal]).to eq(".")
    end

    it "parses localize_number templates into formatter symbols" do
      resolver = described_class.new(
        :en,
        localizer_symbols: {},
        localize_number: "#,##0.### #",
      )

      resolved = resolver.resolve

      expect(resolved).to include(
        decimal: ".",
        group_digits: 3,
        fraction_group_digits: 3,
        group: ",",
        fraction_group: "\u00A0",
      )
    end
  end
end
