# frozen_string_literal: true

require "spec_helper"
require "plurimath/evaluation_request"

RSpec.describe Plurimath::EvaluationRequest do
  fixture = JSON.parse(File.read(File.expand_path("../fixtures/evaluation/request-numeric-v1.json", __dir__)))

  fixture.fetch("cases").each do |row|
    it "matches the independently checked wire for #{row.fetch('id')}" do
      request = row.fetch("request_json") { JSON.generate(row.fetch("request")) }
      expect(described_class.call(request)).to eq(row.fetch("expected_wire"))
    end
  end

  it "keeps literal significance in the ordinary document AST" do
    formula = described_class.formula("type" => "number", "text" => "2.10")
    expect(formula.value.first.value).to eq("2.10")
  end

  it "does not depend on JSON key or binding insertion order" do
    ast = {"type" => "variable", "name" => "x"}
    first = {"schema" => described_class::SCHEMA, "ast" => ast, "bindings" => {"x" => "0.30", "unused" => "1"}}
    second = {"bindings" => {"unused" => "1", "x" => "0.30"}, "ast" => ast, "schema" => described_class::SCHEMA}
    expect(described_class.call(JSON.generate(first))).to eq(described_class.call(JSON.generate(second)))
  end

  it "does not coerce a non-string request" do
    expect(JSON.parse(described_class.call(nil))).to include("ok" => false, "error" => {"code" => "InvalidRequest"})
  end

  it "does not read ambient configuration, files or ENV when strict evaluation defers" do
    row = fixture.fetch("cases").find { |candidate| candidate.fetch("id") == "sqrt-deferred" }
    request = JSON.generate(row.fetch("request"))
    described_class.call(request)
    allow(Plurimath).to receive(:configuration) { raise "ambient configuration" }
    allow(File).to receive(:read) { raise "filesystem read" }
    allow(File).to receive(:binread) { raise "filesystem read" }
    allow(ENV).to receive(:[]) { raise "environment read" }
    expect(described_class.call(request)).to eq(row.fetch("expected_wire"))
  end
end
