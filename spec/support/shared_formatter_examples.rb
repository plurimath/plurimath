# frozen_string_literal: true

require_relative "shared_formatter_fixtures"

module SharedFormatterExamples
  def expect_shared_formatter_output(id, actual)
    row = SharedFormatterFixtures.fetch(id, described_class)
    expect_shared_formatter_value(row, actual)
  end

  def expect_shared_formatter_value(row, actual)
    case row.fetch("comparison")
    when "eq" then expect(actual).to eq(row.fetch("expected"))
    when "nil" then expect(actual).to be_nil
    when "text_kind" then expect(actual).to be_a(String)
    when "alphabet" then expect(actual.chars.all? { |char| row.fetch("expected").include?(char) }).to be(true)
    when "max_length" then expect(actual.length).to be <= row.fetch("expected")
    else raise SharedFormatterFixtures::Error, "unsupported shared formatter comparison"
    end
  end
end

RSpec.configure { |config| config.include SharedFormatterExamples }
