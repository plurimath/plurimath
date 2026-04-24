# frozen_string_literal: true

require "spec_helper"
require "plurimath/fixtures/formula_modules/expected_values"

RSpec.describe Plurimath::Omml::Translator do
  describe "#omml_to_plurimath" do
    it "raises for unsupported typed nodes" do
      expect { described_class.new.omml_to_plurimath(Object.new) }
        .to raise_error(
          Plurimath::Omml::UnsupportedNodeError,
          /Unsupported OMML typed node/,
        )
    end
  end

  describe "Plurimath::Omml#to_formula" do
    {
      "001" => ExpectedValues::EX_001,
      "057" => ExpectedValues::EX_057,
      "121" => ExpectedValues::EX_121,
      "187" => ExpectedValues::EX_187,
    }.each do |fixture_id, expected_formula|
      context "with ##{fixture_id}.omml" do
        let(:file_name) { "spec/plurimath/fixtures/omml/#{fixture_id}.omml" }

        it "parses through the omml repo typed models" do
          expect(Plurimath::Omml.new(File.read(file_name)).to_formula)
            .to eq(expected_formula)
        end
      end
    end

    context "when the omml context has not been populated yet" do
      let(:file_name) { "spec/plurimath/fixtures/omml/001.omml" }

      it "populates the omml context before parsing" do
        require "omml"

        Omml::Configuration.reset_context!

        expect(Plurimath::Omml.new(File.read(file_name)).to_formula)
          .to eq(ExpectedValues::EX_001)
      end
    end
  end
end
