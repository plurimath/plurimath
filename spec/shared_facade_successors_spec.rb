# frozen_string_literal: true

require "spec_helper"
require "support/shared_facade_successors"
require "support/shared_renderer_fixtures"

RSpec.describe SharedFacadeSuccessors do
  it "pins twenty-four successors and preserves the unselected legacy renderer rows" do
    expect(described_class::PROFILES).to eq(%w[writer-fidelity-v1 writer-authored-v1])
    expect(described_class.data.fetch("cases").length).to eq(24)
    original = { "id" => "unselected", "expected" => "unchanged" }
    expect(described_class.row("fixtures/renderer-expectations.yaml", original)).to equal(original)
  end

  it "rejects overlapping sources across selected profiles" do
    allow(FacadeSuccessors).to receive(:load).and_return(
      { "cases" => [{ "source" => { "path" => "fixtures/renderer-expectations.yaml", "id" => "same" } }] },
    )
    cached = described_class.instance_variable_get(:@data)
    described_class.remove_instance_variable(:@data) if described_class.instance_variable_defined?(:@data)
    begin
      expect { described_class.data }.to raise_error(FacadeSuccessors::Error, /duplicate source/)
    ensure
      described_class.instance_variable_set(:@data, cached)
    end
  end

  it "selects the renderer successor with exact public refusals and the original MathML assertion" do
    row = SharedRendererFixtures.row("renderer-mathml-mathml-820-1")
    expect(row.fetch("id")).to eq("renderer-mathml-mathml-820-1-writer-fidelity-v1")
    checks = []
    SharedRendererFixtures.run_program(row) do |actual, expected, comparison|
      checks << [actual, expected, comparison]
      if comparison == "eq"
        expect(actual).to eq(expected)
      else
        expect(comparison).to eq("be_xml_equivalent_to")
        expect(actual).to be_xml_equivalent_to(expected)
      end
    end
    expect(checks.length).to eq(3)
    expect(checks.count { |actual, _, _| actual.is_a?(Hash) && actual["error_class"] == "Plurimath::Math::ParseError" }).to eq(2)
  end

  def refusal_program
    row = SharedRendererFixtures.row("renderer-mathml-mathml-820-1")
    row.fetch("program")["steps"].reject! { |step| step["save"] == "v7" || step["assertion_line"] == 854 }
    row
  end

  it "does not treat successful output as an expected refusal" do
    allow(SharedRendererFixtures).to receive(:render_model).and_return("lossy output")
    checks = []
    SharedRendererFixtures.run_program(refusal_program) { |actual, expected, _| checks << [actual, expected] }
    expect(checks.length).to eq(2)
    expect(checks).to all(satisfy { |actual, expected| actual != expected && actual == { "output" => "lossy output" } })
  end

  it "does not treat a different exception or message as the recorded refusal" do
    allow(SharedRendererFixtures).to receive(:render_model).and_raise(RuntimeError, "different")
    checks = []
    SharedRendererFixtures.run_program(refusal_program) { |actual, expected, _| checks << [actual, expected] }
    expect(checks.length).to eq(2)
    expect(checks).to all(satisfy { |actual, expected| actual != expected && actual == { "error_class" => "RuntimeError", "message" => "different" } })
  end

  it "refuses an undeclared refusal class before any rendering" do
    row = refusal_program
    row.fetch("program").fetch("steps").find { |step| step["kind"] == "assert_refusal" }["error_class"] = "StandardError"
    expect(SharedRendererFixtures).not_to receive(:render_model)
    expect { SharedRendererFixtures.run_program(row) {} }.to raise_error(SharedRendererFixtures::Error, /invalid renderer refusal/)
  end
end
