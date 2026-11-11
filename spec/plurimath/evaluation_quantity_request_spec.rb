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
  end
end
