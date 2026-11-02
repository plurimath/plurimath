# frozen_string_literal: true

require "spec_helper"
require_relative "../support/shared_facade_examples"

RSpec.describe "Base-prefixed number parsing" do
  before do
    @previous_formatter = Plurimath.configuration.number_formatter
    Plurimath.configuration.number_formatter = Plurimath::Formatter::Standard.new
  end

  after { Plurimath.configuration.number_formatter = @previous_formatter }

  # Shared portable cases are declared at their original call sites below.

  describe "AsciiMath" do
    it_behaves_like "shared facade expectation", "facade-base-prefix-parsing-14-variant-72"
    it_behaves_like "shared facade expectation", "facade-base-prefix-parsing-21-variant-72"
    it_behaves_like "shared facade expectation", "facade-base-prefix-parsing-27-variant-72"
    it_behaves_like "shared facade expectation", "facade-base-prefix-parsing-33-variant-72"
    it_behaves_like "shared facade expectation", "facade-base-prefix-parsing-40-variant-72"
    it_behaves_like "shared facade expectation", "facade-base-prefix-parsing-46-variant-72"
    it_behaves_like "shared facade expectation", "facade-base-prefix-parsing-53-variant-72"
    it_behaves_like "shared facade expectation", "facade-base-prefix-parsing-59-variant-72"
    it_behaves_like "shared facade expectation", "facade-base-prefix-parsing-65-variant-72"
  end

  describe "LaTeX" do
    it_behaves_like "shared facade expectation", "facade-base-prefix-parsing-14-variant-76"
    it_behaves_like "shared facade expectation", "facade-base-prefix-parsing-21-variant-76"
    it_behaves_like "shared facade expectation", "facade-base-prefix-parsing-27-variant-76"
    it_behaves_like "shared facade expectation", "facade-base-prefix-parsing-33-variant-76"
    it_behaves_like "shared facade expectation", "facade-base-prefix-parsing-40-variant-76"
    it_behaves_like "shared facade expectation", "facade-base-prefix-parsing-46-variant-76"
    it_behaves_like "shared facade expectation", "facade-base-prefix-parsing-53-variant-76"
    it_behaves_like "shared facade expectation", "facade-base-prefix-parsing-59-variant-76"
    it_behaves_like "shared facade expectation", "facade-base-prefix-parsing-65-variant-76"
  end

  describe "UnicodeMath" do
    it_behaves_like "shared facade expectation", "facade-base-prefix-parsing-14-variant-80"
    it_behaves_like "shared facade expectation", "facade-base-prefix-parsing-21-variant-80"
    it_behaves_like "shared facade expectation", "facade-base-prefix-parsing-27-variant-80"
    it_behaves_like "shared facade expectation", "facade-base-prefix-parsing-33-variant-80"
    it_behaves_like "shared facade expectation", "facade-base-prefix-parsing-40-variant-80"
    it_behaves_like "shared facade expectation", "facade-base-prefix-parsing-46-variant-80"
    it_behaves_like "shared facade expectation", "facade-base-prefix-parsing-53-variant-80"
    it_behaves_like "shared facade expectation", "facade-base-prefix-parsing-59-variant-80"
    it_behaves_like "shared facade expectation", "facade-base-prefix-parsing-65-variant-80"
  end

  describe "HTML" do
    it_behaves_like "shared facade expectation", "facade-base-prefix-parsing-14-variant-84"
    it_behaves_like "shared facade expectation", "facade-base-prefix-parsing-21-variant-84"
    it_behaves_like "shared facade expectation", "facade-base-prefix-parsing-27-variant-84"
    it_behaves_like "shared facade expectation", "facade-base-prefix-parsing-33-variant-84"
    it_behaves_like "shared facade expectation", "facade-base-prefix-parsing-40-variant-84"
    it_behaves_like "shared facade expectation", "facade-base-prefix-parsing-46-variant-84"
    it_behaves_like "shared facade expectation", "facade-base-prefix-parsing-53-variant-84"
    it_behaves_like "shared facade expectation", "facade-base-prefix-parsing-59-variant-84"
    it_behaves_like "shared facade expectation", "facade-base-prefix-parsing-65-variant-84"
  end

  describe "round-trip rendering" do
    it_behaves_like "shared facade expectation", "facade-base-prefix-parsing-88"

    it_behaves_like "shared facade expectation", "facade-base-prefix-parsing-93"

    it_behaves_like "shared facade expectation", "facade-base-prefix-parsing-98"

    it_behaves_like "shared facade expectation", "facade-base-prefix-parsing-103"

    it_behaves_like "shared facade expectation", "facade-base-prefix-parsing-108"

    it_behaves_like "shared facade expectation", "facade-base-prefix-parsing-113"
  end
end
