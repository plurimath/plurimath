# frozen_string_literal: true

require "spec_helper"
require_relative "support/shared_grammar_fixtures"

RSpec.describe SharedGrammarFixtures do
  let(:row) do
    { "format" => "latex", "id" => "grammar-latex-001", "input" => "x", "label" => "projection",
      "locale" => nil, "rule" => "expression", "source" => { "path" => "spec/plurimath/latex/parse_spec.rb", "line" => 1 },
      "transforms" => [], "observations" => [{ "comparison" => "read", "path" => [] }] }
  end

  it "rejects reads without an actual comparison" do
    expect { described_class.validate_case!(row) }.to raise_error(SharedGrammarFixtures::Error, /at least one comparison/)
  end

  it "allows ordered reads before a real comparison" do
    row.fetch("observations") << { "comparison" => "eq", "path" => [], "expected" => "x" }
    expect { described_class.validate_case!(row) }.not_to raise_error
  end
end
