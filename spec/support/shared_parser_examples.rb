# frozen_string_literal: true

require_relative "shared_parser_fixtures"

RSpec.shared_examples "shared parser constructor expectation" do |id, family = "parser-expectations"|
  it "parses shared constructor expectation #{id}" do
    row = SharedParserFixtures.case_data(id, family)
    operation = lambda do
      row.fetch("configuration").each do |key, value|
        raise SharedParserFixtures::Error, "unsupported parser configuration" unless key == "locale"

        expect(Plurimath.configuration.locale.to_s).to eq(value)
      end
      expected_class = "Plurimath::#{row.fetch('parser_class')}"
      raise SharedParserFixtures::Error, "shared parser class differs" unless described_class.name == expected_class

      memo = {}
      if row.key?("expected")
        input = SharedParserFixtures.parser_input(row)
        expected = SharedModelRecipes.build(row.fetch("expected"), memo)
        raise SharedParserFixtures::Error, "expected parser model must inherit Core" unless expected.is_a?(Plurimath::Math::Core)

        expect(described_class.new(input).parse).to eq(expected)
      else
        actuals = {}
        row.fetch("sequence").each do |step|
          input = SharedParserFixtures.parser_input(step)
          parse_id = step.fetch("parse_id")
          actual = lambda do
            actuals.fetch(parse_id) { actuals[parse_id] = described_class.new(input).parse }
          end
          step.fetch("observations").each do |observation|
            case observation.fetch("kind")
            when "model_equal"
              expected = SharedModelRecipes.build(observation.fetch("expected"), memo)
              raise SharedParserFixtures::Error, "expected parser model must inherit Core" unless expected.is_a?(Plurimath::Math::Core)

              expect(actual.call).to eq(expected)
            when "render_equal", "render_include"
              method = observation.fetch("method")
              unless %w[to_asciimath to_latex to_mathml to_omml to_html to_unicodemath].include?(method)
                raise SharedParserFixtures::Error, "unsupported parser render observation"
              end
              expected = SharedModelRecipes.build(observation.fetch("expected"), memo)
              raise SharedParserFixtures::Error, "render observation must be text" unless expected.is_a?(String)

              if observation.fetch("kind") == "render_include"
                expect(actual.call.public_send(method)).to include(expected)
              else
                expect(actual.call.public_send(method)).to eq(expected)
              end
            when "parse_error"
              unless observation.fetch("category") == "parse_error"
                raise SharedParserFixtures::Error, "unsupported native parser refusal"
              end

              error_class = described_class.name.start_with?("Plurimath::Asciimath") ? Parslet::ParseFailed : Parsanol::ParseFailed
              expect { actual.call }.to raise_error(error_class)
            else
              raise SharedParserFixtures::Error, "unknown parser observation"
            end
          end
        end
      end
    end
    case row.fetch("configuration_mode", "assert")
    when "assert" then operation.call
    when "apply"
      unless row.fetch("configuration").keys == ["locale"] && row.fetch("configuration").fetch("locale").is_a?(String)
        raise SharedParserFixtures::Error, "unsupported applied parser configuration"
      end
      Plurimath.with_configuration do |config|
        config.locale = row.fetch("configuration").fetch("locale").to_sym
        operation.call
      end
    else raise SharedParserFixtures::Error, "unsupported parser configuration mode"
    end
  end
end
