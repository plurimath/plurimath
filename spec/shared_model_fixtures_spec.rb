# frozen_string_literal: true

require "spec_helper"
require_relative "support/shared_model_fixtures"

RSpec.describe SharedModelFixtures do
  let(:input) { "<math>\n  <mn>0x7F800000</mn>\n</math>\n" }

  def shared_number
    described_class.model("mathml/tokens", "mathml-tokens-027", input: input)
  end

  it "loads the recorded formula and number state" do
    formula = shared_number

    expect(formula).to be_a(Plurimath::Math::Formula)
    expect(formula.input_string).to eq(input)
    expect(formula.value.first).to be_a(Plurimath::Math::Number)
    expect(formula.value.first.value).to eq("0x7F800000")
  end

  it "returns fresh objects when a previous expectation is changed" do
    original = shared_number
    original.value.first.value = "changed"

    expect(shared_number.value.first.value).to eq("0x7F800000")
  end

  unless RUBY_ENGINE == "opal"
    it "does not share mutable strings with cached YAML" do
      original = shared_number
      original.value.first.value.replace("changed")

      expect(shared_number.value.first.value).to eq("0x7F800000")
    end

    it "resolves native fixtures independently of the current directory" do
      Dir.chdir(__dir__) do
        expect(described_class.load_payload("mathml/tokens").fetch("input_format"))
          .to eq("mathml")
      end
    end
  end

  it "rejects a different native input" do
    expect do
      described_class.model("mathml/tokens", "mathml-tokens-027", input: "different")
    end.to raise_error(SharedModelFixtures::Error, /input differs/)
  end

  it "rejects a missing case instead of choosing a fallback" do
    expect do
      described_class.model("mathml/tokens", "missing", input: input)
    end.to raise_error(SharedModelFixtures::Error, /expected one shared model/)
  end

  it "rejects paths outside the supported corpus" do
    expect do
      described_class.model("../../other", "missing", input: input)
    end.to raise_error(SharedModelFixtures::Error, /unsupported shared model payload/)
  end

  it "rejects non-model mappings whose key types were not recorded" do
    expect { described_class.build("options" => "unknown") }
      .to raise_error(SharedModelFixtures::Error, /unsupported shared model mapping/)
  end

  it "rejects projected models that cannot be reconstructed" do
    expect do
      described_class.build("class" => "Math::Function::Unitsml", "fields" => {})
    end.to raise_error(SharedModelFixtures::Error, /unsupported shared model class/)
  end

  it "rejects classes outside the model hierarchy" do
    expect do
      described_class.build("class" => "Math::ParseError", "fields" => {})
    end.to raise_error(SharedModelFixtures::Error, /must inherit Math::Core/)
  end

  it "rejects fields the model does not expose" do
    expect do
      described_class.build("class" => "Math::Number", "fields" => { "unknown" => true })
    end.to raise_error(SharedModelFixtures::Error, /unsupported shared model field/)
  end
end
