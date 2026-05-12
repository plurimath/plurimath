# frozen_string_literal: true

require "spec_helper"

RSpec.describe Plurimath::Deprecation do
  before do
    described_class.behavior = described_class::DEFAULT_BEHAVIOR
  end

  after do
    described_class.behavior = described_class::DEFAULT_BEHAVIOR
  end

  describe ".warn" do
    it "warns once per feature by default" do
      allow(Kernel).to receive(:warn)
      allow(Plurimath::DeprecationError).to receive(:new).and_call_original
      feature = "number_formatter.old_option.once.#{Plurimath.xml_engine.name}"

      2.times do
        described_class.warn(
          feature: feature,
          since: "0.10",
          replacement: "number_formatter.new_option",
          message: "Old option will be removed",
        )
      end

      expect(Kernel).to have_received(:warn).once.with(
        "[plurimath][DEPRECATION] #{feature} is deprecated since 0.10. " \
        "Use number_formatter.new_option instead. " \
        "Old option will be removed.",
      )
      expect(Plurimath::DeprecationError).to have_received(:new).once
    end

    it "raises when configured to raise" do
      described_class.behavior = :raise

      expect do
        described_class.warn(feature: "number_formatter.old_option.raise")
      end.to raise_error(
        Plurimath::DeprecationError,
        "[plurimath][DEPRECATION] number_formatter.old_option.raise is deprecated.",
      )
    end

    it "does not build or emit warnings when silenced" do
      described_class.behavior = :silence

      allow(Kernel).to receive(:warn)
      allow(Plurimath::DeprecationError).to receive(:new)

      described_class.warn(feature: "number_formatter.old_option.silence")

      expect(Kernel).not_to have_received(:warn)
      expect(Plurimath::DeprecationError).not_to have_received(:new)
    end

    it "requires a feature identifier" do
      expect do
        described_class.warn(feature: nil)
      end.to raise_error(
        Plurimath::ConfigurationError,
        "deprecation feature must be provided",
      )
    end

    it "requires a feature identifier when silenced" do
      described_class.behavior = :silence

      expect do
        described_class.warn(feature: nil)
      end.to raise_error(
        Plurimath::ConfigurationError,
        "deprecation feature must be provided",
      )
    end
  end

  describe ".behavior" do
    it "defaults to warning behavior" do
      expect(described_class.behavior).to be(:warn)
    end
  end

  describe ".behavior=" do
    it "updates deprecation behavior" do
      described_class.behavior = :raise

      expect(described_class.behavior).to be(:raise)
    end

    it "rejects unsupported notification behavior" do
      expect do
        described_class.behavior = :invalid
      end.to raise_error(
        Plurimath::ConfigurationError,
        /unsupported deprecation behavior/,
      )
    end
  end
end
