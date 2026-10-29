# frozen_string_literal: true

require "spec_helper"
require_relative "../../../support/shared_formatter_examples"

RSpec.describe Plurimath::Formatter::Numbers::SignRenderer do
  describe "#apply" do
    it "leaves positive numbers unsigned by default" do
      renderer = described_class.new

      expect_shared_formatter_output("sign-renderer-010", renderer.apply(10, "10"))
    end

    it "adds a plus sign for positive numbers when requested" do
      renderer = described_class.new(:plus)

      expect_shared_formatter_output("sign-renderer-016", renderer.apply(10, "10"))
    end

    it "keeps negative signs before rendered base notation" do
      renderer = described_class.new(:plus)

      expect_shared_formatter_output("sign-renderer-022", renderer.apply(-10, "0b10,10"))
    end

    it "can apply signs from parsed parts" do
      renderer = described_class.new(:plus)
      parts = Plurimath::Formatter::Numbers::Parts.new(
        sign: -1,
        base: 10,
        integer_digits: "10",
        fraction_digits: "",
      )

      expect_shared_formatter_output("sign-renderer-034", renderer.apply(parts, "10"))
    end
  end
end
