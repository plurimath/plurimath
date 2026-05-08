# frozen_string_literal: true

require "spec_helper"

RSpec.describe Plurimath::Configuration do
  around do |example|
    previous_behavior = Plurimath::Deprecation.behavior
    previous_number_formatter = Plurimath.configuration.number_formatter
    example.run
  ensure
    Plurimath::Deprecation.behavior = previous_behavior
    Plurimath.configuration.number_formatter = previous_number_formatter
  end

  describe ".configuration" do
    it "returns the shared configuration" do
      expect(Plurimath.configuration).to be_a(described_class)
    end
  end

  describe ".configure" do
    it "yields the shared configuration" do
      yielded_config = nil

      result = Plurimath.configure do |config|
        yielded_config = config
        :configured
      end

      expect(yielded_config).to be(Plurimath.configuration)
      expect(result).to be(:configured)
    end

    it "allows interacting with deprecation configuration" do
      Plurimath.configure do |config|
        config.deprecation.behavior = :raise
      end

      expect(Plurimath::Deprecation.behavior).to be(:raise)
    end

    it "allows setting a number formatter" do
      formatter = Plurimath::Formatter::Standard.new

      Plurimath.configure do |config|
        config.number_formatter = formatter
      end

      expect(Plurimath.configuration.number_formatter).to be(formatter)
    end
  end

  describe "#deprecation" do
    it "returns the deprecation module" do
      expect(Plurimath.configuration.deprecation).to be(Plurimath::Deprecation)
    end
  end

  describe "#number_formatter" do
    it "defaults to nil" do
      expect(described_class.new.number_formatter).to be_nil
    end
  end
end
