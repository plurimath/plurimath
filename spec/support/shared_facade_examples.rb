# frozen_string_literal: true

require_relative "shared_facade_fixtures"

module SharedFacadeExamples
  def shared_facade_expectations(id)
    row = SharedFacadeFixtures.row(id)
    owner = {
      "spec/plurimath/number_formatter_spec.rb" => "Plurimath::NumberFormatter",
      "spec/plurimath/base_prefix_parsing_spec.rb" => nil,
      "spec/plurimath/base_number_prefix_spec.rb" => "Plurimath::BaseNumberPrefix",
      "spec/plurimath/math_spec.rb" => "Plurimath::Math",
      "spec/plurimath/unitsml_spec.rb" => "Plurimath::Unitsml",
    }.fetch(row.fetch("source").fetch("file")) { raise SharedFacadeFixtures::Error, "unsupported facade source boundary" }
    actual_owner = described_class&.name
    raise SharedFacadeFixtures::Error, "facade described class differs" unless actual_owner == owner
    SharedFacadeFixtures.run(row, self) do |step, actual, expected|
      case step.fetch("kind")
      when "facade_no_error" then expect { actual.call }.not_to raise_error
      when "facade_error"
        klass = SharedFacadeFixtures.error_class(expected.fetch("category"))
        if expected.key?("message")
          expect { actual.call }.to raise_error(klass, SharedFacadeFixtures.error_message(expected.fetch("message")))
        else
          expect { actual.call }.to raise_error(klass)
        end
      when "assert"
        case step.fetch("comparison")
        when "eq" then expect(actual).to eq(expected)
        when "eql" then expect(actual).to eql(expected)
        when "be_xml_equivalent_to" then expect(actual).to be_xml_equivalent_to(expected)
        when "be_nil" then expect(actual).to be_nil
        when "be_base_notation" then expect(actual).to be_base_notation
        when "be_negative" then expect(actual).to be_negative
        when "be_fractional" then expect(actual).to be_fractional
        when "model_kind"
          klass = case step.fetch("expected_kind")
                  when "Math::Number" then Plurimath::Math::Number
                  when "Formatter::Numbers::FormattedNumber" then Plurimath::Formatter::Numbers::FormattedNumber
                  when "Formatter::Numbers::FormattedNotation" then Plurimath::Formatter::Numbers::FormattedNotation
                  else raise SharedFacadeFixtures::Error, "unsupported numeric model kind"
                  end
          expect(actual).to be_a(klass)
        else raise SharedFacadeFixtures::Error, "unsupported facade comparison"
        end
      else raise SharedFacadeFixtures::Error, "unsupported facade check"
      end
    end
  end
end

RSpec.configure { |config| config.include SharedFacadeExamples }
RSpec.shared_examples "shared facade expectation" do |id|
  it "checks shared facade expectation #{id}" do
    shared_facade_expectations(id)
  end
end
