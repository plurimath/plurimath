# frozen_string_literal: true

require "support/shared_renderer_fixtures"

RSpec.shared_examples "shared renderer fixture" do |id|
  row = SharedRendererFixtures.row(id)
  let(:__shared_renderer_example_memo) { {} }
  it "#{id}: #{row.fetch('description')}" do
    # Each engine invokes the example body. Explicit source let/subject values
    # retain their original RSpec lifetime; direct calls execute on each run.
    check = lambda do |observed, value, comparison|
      expected = value.is_a?(String) ? value.dup : value
      case comparison
      when "eq" then expect(observed).to eq(expected)
      when "eql" then expect(observed).to eql(expected)
      when "not_eq" then expect(observed).not_to eq(expected)
      when "not_eql" then expect(observed).not_to eql(expected)
      when "match" then expect(observed).to match(expected)
      when "be_xml_equivalent_to" then expect(observed).to be_xml_equivalent_to(expected)
      when "be_empty" then expect(observed).to be_empty
      when "not_be_nil" then expect(observed).not_to be_nil
      when "include" then expect(observed).to include(expected)
      when "not_include" then expect(observed).not_to include(expected)
      when "start_with" then expect(observed).to start_with(expected)
      when "not_start_with" then expect(observed).not_to start_with(expected)
      when "end_with" then expect(observed).to end_with(expected)
      when "not_end_with" then expect(observed).not_to end_with(expected)
      when "model_class" then expect(observed).to be_a(SharedModelRecipes.model_class(expected))
      when "not_model_class" then expect(observed).not_to be_a(SharedModelRecipes.model_class(expected))
      when "text_kind" then expect(observed).to be_a(String)
      when "roundtrip_model_eq" then expect(observed.fetch(:actual)).to eq(observed.fetch(:expected))
      else raise SharedRendererFixtures::Error, "unsupported renderer comparison"
      end
    end
    if row["program"]
      execute = lambda do
        SharedRendererFixtures.run_program(row, context: self, example_memo: __shared_renderer_example_memo) { |actual, expected, comparison| check.call(actual, expected, comparison) }
      end
      if row.fetch("program")["no_error"]
        expect { execute.call }.not_to raise_error
      elsif row.fetch("program")["aggregate_failures"]
        aggregate_failures { execute.call }
      else
        execute.call
      end
    else
      actual = SharedRendererFixtures.render(row, example_memo: __shared_renderer_example_memo)
      observations = row["observations"] || [{ "comparison" => row.fetch("comparison"), "expected" => row.fetch("expected") }]
      observations.each do |observation|
        observed = observation["observation"] ? SharedRendererFixtures.observe(actual, observation.fetch("observation")) : actual
        check.call(observed, observation.fetch("expected"), observation.fetch("comparison"))
      end
    end
  end
end
