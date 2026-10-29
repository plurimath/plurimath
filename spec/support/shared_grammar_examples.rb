# frozen_string_literal: true

require_relative "shared_grammar_fixtures"

RSpec.shared_examples "shared grammar expectations" do |ids|
  raise SharedGrammarFixtures::Error, "empty or duplicate grammar selection" if ids.empty? || ids.uniq.length != ids.length

  ids.each do |id|
    data = SharedGrammarFixtures.fetch(id)
    unless described_class.name == SharedGrammarFixtures::CLASSES.fetch(data.fetch("format"))
      raise SharedGrammarFixtures::Error, "grammar fixture parser class differs"
    end

    it "checks #{id}: #{data.fetch('label')}" do
      SharedGrammarFixtures.configured(data) do
        parse = lambda do
          parser = described_class.new
          parser = parser.number if data.fetch("rule") == "number"
          parser.parse(SharedGrammarFixtures.input(data))
        end
        if data.fetch("observations").first.fetch("comparison") == "parse_failure"
          error_class = described_class < Parsanol::Parser ? Parsanol::ParseFailed : Parslet::ParseFailed
          expect { parse.call }.to raise_error(error_class)
        else
          tree = parse.call
          data.fetch("observations").each do |check|
            actual = SharedGrammarFixtures.project(tree, check.fetch("path"))
            if check.fetch("comparison") == "read"
              next
            elsif check.fetch("comparison") == "nil"
              expect(actual).to be_nil
            else
              expect(actual).to eq(SharedGrammarFixtures.literal(check.fetch("expected")))
            end
          end
        end
      end
    end
  end
end
