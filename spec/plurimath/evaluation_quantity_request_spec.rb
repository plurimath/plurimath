# frozen_string_literal: true

require "spec_helper"
require "plurimath/evaluation_request"

RSpec.describe Plurimath::EvaluationRequest do
  fixture = JSON.parse(File.read(File.expand_path("../fixtures/evaluation/request-quantity-v1.json", __dir__)))

  context "with the serialized quantity profile" do
    fixture.fetch("cases").each do |row|
      it "matches the sealed native wire for #{row.fetch('id')}" do
        expect(described_class.call(row.fetch("request_json"))).to eq(row.fetch("expected_wire"))
      end
    end

    it "refuses a fractional factor when UnitsML produces a float" do
      row = fixture.fetch("known_gap")
      reference = JSON.parse(row.fetch("reference_wire"))
      expect(reference.dig("result", "value", "canonical_magnitude")).to eq("1/10")

      actual = JSON.parse(described_class.call(row.fetch("request_json")))
      expect(actual.fetch("error")).to eq(
        "class" => "error", "code" => row.fetch("expected_ruby_refusal"), "detail" => "InexactPower",
      )
    end
  end
end
