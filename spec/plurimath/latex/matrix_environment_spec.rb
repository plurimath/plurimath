# frozen_string_literal: true

require "spec_helper"
require_relative "../../support/shared_corpus"

RSpec.describe Plurimath::Latex::Parser, :shared_corpus do
  let(:matrix_cases) do
    YAML.safe_load_file(
      File.join(SharedCorpus::CORPUS_ROOT, "latex", "matrices.yaml"), aliases: false
    ).fetch("cases")
  end

  %w[latex-matrix-parens latex-matrix-bars].each do |id|
    it "preserves the native matrix model and renderings for #{id}" do
      fixture = matrix_cases.find { |row| row.fetch("id") == id }
      skip "Parsanol native extension unavailable" unless Parsanol::Native.available?
      allow(Parsanol::Native).to receive(:parse).and_call_original

      formula = Plurimath::Math.parse(fixture.fetch("input"), :latex)

      expect(Parsanol::Native).to have_received(:parse)
      expect(formula.value.first).to be_a(Plurimath::Math::Function::Table)
      fixture.fetch("expected").each do |target, output|
        expect(SharedCorpus.render(formula, target, {})).to eq(output)
      end
      expect(CorpusGenerator.serialize_node(formula, id)).to eq(fixture.fetch("model"))
    end
  end
end
