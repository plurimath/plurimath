# frozen_string_literal: true

require "spec_helper"

RSpec.describe Plurimath::Deprecation do
  around do |example|
    previous_behavior = described_class.behavior
    described_class.clear!
    example.run
  ensure
    described_class.behavior = previous_behavior
    described_class.clear!
  end

  describe ".warn" do
    context "with collect behavior (default)" do
      it "collects deprecation notices" do
        feature = "test.collect.#{Process.pid}"
        described_class.warn(
          feature: feature,
          since: "0.10",
          replacement: "new_option",
          message: "Will be removed",
        )

        expect(described_class.notices.size).to eq(1)
        notice = described_class.notices.first
        expect(notice).to be_a(Plurimath::DeprecationError)
        expect(notice.feature).to eq(feature)
        expect(notice.to_s).to include("since 0.10")
        expect(notice.to_s).to include("Use new_option instead")
      end

      it "deduplicates notices per feature" do
        feature = "test.dedup.#{Process.pid}"
        3.times { described_class.warn(feature: feature) }

        expect(described_class.notices.size).to eq(1)
      end

      it "collects different features separately" do
        described_class.warn(feature: "test.feature_a")
        described_class.warn(feature: "test.feature_b")

        expect(described_class.notices.size).to eq(2)
      end
    end

    context "with raise behavior" do
      before { described_class.behavior = :raise }

      it "raises a DeprecationError" do
        expect do
          described_class.warn(feature: "test.raise_mode")
        end.to raise_error(
          Plurimath::DeprecationError,
          "[plurimath][DEPRECATION] test.raise_mode is deprecated.",
        )
      end

      it "includes replacement and version info in the error" do
        expect do
          described_class.warn(
            feature: "test.raise_details",
            since: "0.10",
            remove_in: "1.0",
            replacement: "new_method",
          )
        end.to raise_error(
          Plurimath::DeprecationError,
          /since 0\.10.*removed in 1\.0.*Use new_method instead/,
        )
      end
    end

    context "with silence behavior" do
      before { described_class.behavior = :silence }

      it "does not collect notices" do
        described_class.warn(feature: "test.silence_mode")

        expect(described_class.notices).to be_empty
      end
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
    it "defaults to collect behavior" do
      expect(described_class.behavior).to be(:collect)
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

  describe ".notices" do
    it "returns collected DeprecationError objects" do
      described_class.warn(feature: "test.notices_a")
      described_class.warn(feature: "test.notices_b")

      expect(described_class.notices).to all(be_a(Plurimath::DeprecationError))
      expect(described_class.notices.map(&:feature)).to contain_exactly("test.notices_a", "test.notices_b")
    end
  end

  describe ".clear!" do
    it "removes all collected notices" do
      described_class.warn(feature: "test.clear")
      expect(described_class.notices).not_to be_empty

      described_class.clear!

      expect(described_class.notices).to be_empty
    end
  end
end

RSpec.describe Plurimath::DeprecationError do
  subject(:error) do
    described_class.new(
      feature: "old_api",
      since: "0.10",
      remove_in: "1.0",
      replacement: "new_api",
      message: "Please migrate",
    )
  end

  describe "#severity" do
    it "returns :warning" do
      expect(error.severity).to be(:warning)
    end
  end

  describe "#feature" do
    it "returns the feature name" do
      expect(error.feature).to eq("old_api")
    end
  end

  describe "#replacement" do
    it "returns the replacement" do
      expect(error.replacement).to eq("new_api")
    end
  end

  describe "#since" do
    it "returns the since version" do
      expect(error.since).to eq("0.10")
    end
  end

  describe "#remove_in" do
    it "returns the remove_in version" do
      expect(error.remove_in).to eq("1.0")
    end
  end

  describe "#to_s" do
    it "includes all deprecation information" do
      expect(error.to_s).to eq(
        "[plurimath][DEPRECATION] old_api is deprecated since 0.10 " \
        "and will be removed in 1.0. Use new_api instead. Please migrate.",
      )
    end

    it "handles minimal information" do
      minimal = described_class.new(feature: "simple")
      expect(minimal.to_s).to eq("[plurimath][DEPRECATION] simple is deprecated.")
    end
  end
end
