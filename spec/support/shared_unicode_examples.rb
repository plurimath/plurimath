# frozen_string_literal: true

require_relative "shared_unicode_fixtures"

RSpec.shared_examples "shared Unicode external expectations" do |boundary|
  definition = SharedUnicodeFixtures::BOUNDARIES.fetch(boundary) { raise SharedUnicodeFixtures::Error, "unknown Unicode boundary" }
  unless described_class.name == "Plurimath::#{definition.fetch('class')}"
    raise SharedUnicodeFixtures::Error, "Unicode fixture parser class differs"
  end

  SharedUnicodeFixtures.cases(boundary).each do |row|
    context "contains unicdemath-tests example ##{row.fetch('index')}" do
      # Keep the native subjects: raw parsing calls unicode_encode_entities and
      # post_processing; model parsing receives remove_prefix(input).
      let(:string) do
        input = SharedUnicodeFixtures.input(row)
        boundary == "model" ? remove_prefix(input.to_s) : input
      end

      it "matches shared Unicode #{boundary} expectation #{row.fetch('id')}" do
        outcome = row.fetch("outcome")
        case outcome.fetch("kind")
        when "equal"
          raise SharedUnicodeFixtures::Error, "unexpected equality fields" unless outcome.keys == ["kind"]

          expect(formula).to eq(SharedUnicodeFixtures.expectation(row, boundary))
        when "parse_error"
          expect { formula }.to raise_error(Parsanol::ParseFailed, SharedUnicodeFixtures.refusal_pattern(outcome))
        else
          raise SharedUnicodeFixtures::Error, "unsupported Unicode outcome"
        end
      end
    end
  end
end
