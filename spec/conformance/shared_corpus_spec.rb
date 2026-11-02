# frozen_string_literal: true

require "spec_helper"
require_relative "../support/shared_corpus"

RSpec.describe "shared corpus conformance", :shared_corpus do # rubocop:disable RSpec/DescribeClass
  SharedCorpus.load.each do |row|
    # Bind each shared-data row into its example without repeated fixture loads.
    # rubocop:disable RSpec/LeakyLocalVariable
    kase = row.fetch(:case)
    format = row.fetch(:format)
    label = "#{row.fetch(:path)} / #{kase.fetch('id')} / #{format.name}"
    # rubocop:enable RSpec/LeakyLocalVariable

    it label do
      # The shared generator explicitly refuses any canonical engine but Ox.
      expect(Plurimath.xml_engine.to_s).to eq("Plurimath::XmlEngine::OxEngine")
      if row.fetch(:kind) == :rejection
        aggregate_failures("#{label} / preprocessing and refusal") do
          expect(CorpusGenerator.preprocessed_text(format, kase.fetch("input")))
            .to eq(kase.fetch("preprocessed"))
          expect { Plurimath::Math.parse(kase.fetch("input"), format.name.to_sym) }
            .to raise_error(Plurimath::Math::ParseError)
          expect(SharedCorpus.rejection_error(format, kase.fetch("input")))
            .to eq(kase.fetch("error"))
        end
        next
      end

      # Match the generator's call sequence: one formula and one formatter,
      # reused across targets, with the model recorded after rendering.
      formula = Plurimath::Math.parse(kase.fetch("input"), format.name.to_sym)
      preprocessed = CorpusGenerator.preprocessed_text(format, kase.fetch("input"))
      tree = format.parse_tree.call(preprocessed)
      options = SharedCorpus.call_options(kase["call"])
      aggregate_failures(label) do
        aggregate_failures("preprocessing") do
          expect(preprocessed).to eq(kase.fetch("preprocessed"))
        end
        aggregate_failures("parse tree") do
          expect(SharedCorpus.serialize_tree(tree, label)).to eq(kase.fetch("parse_tree"))
        end
        row.fetch(:targets).each do |target|
          aggregate_failures("#{label} / target=#{target}") do
            expected = kase.fetch("expected").fetch(target)
            expected = { "output" => expected } if row.fetch(:kind) == :strings
            if expected.key?("output")
              expect(SharedCorpus.render(formula, target, options))
                .to eq(expected.fetch("output"))
            else
              expect(expected.fetch("error").fetch("category")).to eq("parse_error")
              expect { SharedCorpus.render(formula, target, options) }
                .to raise_error(Plurimath::Math::ParseError)
            end
          end
        end
        aggregate_failures("formula model after rendering") do
          expect(CorpusGenerator.serialize_node(formula, label)).to eq(kase.fetch("model"))
        end
      end
    end
  end
end
