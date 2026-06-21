# frozen_string_literal: true

require "spec_helper"

RSpec.describe Plurimath::Formatter::SupportedLocales do
  describe ".key_for" do
    it "returns a supported symbol locale key" do
      expect(described_class.key_for(:fr)).to be(:fr)
    end

    it "returns a supported string locale key" do
      expect(described_class.key_for("fr-CA")).to eq(:"fr-CA")
    end

    it "returns nil for an unsupported locale" do
      expect(described_class.key_for(:unknown)).to be_nil
    end
  end

  describe ".key_for!" do
    it "returns a supported locale key" do
      expect(described_class.key_for!(:fr)).to be(:fr)
    end

    it "returns nil for a nil locale" do
      expect(described_class.key_for!(nil)).to be_nil
    end

    it "raises for an unsupported locale" do
      expect do
        described_class.key_for!(:unknown)
      end.to raise_error(
        Plurimath::Errors::UnsupportedLocale,
        /\[plurimath\] Unsupported locale :unknown\./,
      )
    end
  end

  describe ".decimal_for" do
    it "uses a supported symbol locale decimal separator" do
      expect(described_class.decimal_for(:fr, default: ".")).to eq(",")
    end

    it "uses a supported string locale decimal separator" do
      expect(described_class.decimal_for("fr-CA", default: ".")).to eq(",")
    end

    it "uses the default for an unsupported locale" do
      expect(described_class.decimal_for(:unknown, default: ".")).to eq(".")
    end
  end
end
