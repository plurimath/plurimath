# frozen_string_literal: true

require "spec_helper"
require_relative "support/shared_formatter_examples"

RSpec.describe SharedFormatterFixtures do
  described_class.rows.each do |row|
    it "executes the authored input recipe for #{row.fetch('id')}" do
      expect_shared_formatter_value(row, described_class.actual(row))
    end
  end
end
