# frozen_string_literal: true

require "spec_helper"
require_relative "../../scripts/roundtrip_cases"

# The cross-language uncertainty round-trip cases written for
# plurimath-testsuite (scripts/roundtrip_cases.rb), checked against the
# round-trip matrix of docs/uncertainty.adoc.
module RoundtripCasesSpecData
  module_function

  # Computed once per process, not once per example and XML engine pass.
  def payloads
    @payloads ||= RoundtripCases.payloads
  end

  def cases
    @cases ||= payloads.flat_map { |payload| payload["cases"] }
  end

  def find(id)
    cases.find { |entry| entry["id"] == id } || raise("no case #{id}")
  end

  def unit?(entry)
    entry["source"]["input"].match?(/unitsml\(|\$unit/)
  end

  def refused?(entry)
    entry["expected"].values.all? { |target| target.key?("refusal") }
  end
end

RSpec.describe RoundtripCases do
  let(:cases) { RoundtripCasesSpecData.cases }

  def find(id)
    RoundtripCasesSpecData.find(id)
  end

  it "writes one payload per group in the roundtrip schema" do
    payloads = RoundtripCasesSpecData.payloads

    expect(payloads.map { |payload| payload["schema"] }.uniq)
      .to eq(["plurimath-stage/roundtrip/1"])
    expect(payloads.map { |payload| payload["group"] })
      .to eq(described_class::GROUPS.map(&:first))
  end

  it "gives every case a unique id prefixed by its group" do
    ids = cases.map { |entry| entry["id"] }

    expect(ids.uniq).to eq(ids)
    expect(ids).to all(match(/\A[a-z0-9-]+\.[a-z0-9-]+\z/))
  end

  it "covers every target for every case" do
    expect(cases.map { |entry| entry["expected"].keys }.uniq)
      .to eq([%w[asciimath unicode mathml omml]])
  end

  it "reads every result without a unit back exactly in every target" do
    exact = cases.reject do |entry|
      RoundtripCasesSpecData.unit?(entry) ||
        RoundtripCasesSpecData.refused?(entry)
    end

    expect(exact).not_to be_empty
    exact.each do |entry|
      expect(entry["expected"].values.map { |target| target["lossless"] })
        .to all(be(true)), entry["id"]
    end
  end

  it "keeps a UnitsML unit only through AsciiMath" do
    units = cases.select do |entry|
      entry["source"]["language"] == "asciimath" &&
        RoundtripCasesSpecData.unit?(entry)
    end

    rendered = %w[unicode mathml omml]
    expect(units).not_to be_empty
    units.each do |entry|
      expected = entry["expected"]
      expect(expected["asciimath"]["lossless"]).to be(true), entry["id"]
      rendered.each do |name|
        expect(expected[name]["lossless"]).to be(false), entry["id"]
        expect(expected[name]["loss"])
          .to match(/\Aunit: Unitsml ".+" reads back as rendered formula/)
      end
    end
  end

  it "writes a multi-letter UnicodeMath unit after the AsciiMath call" do
    asciimath = find("unicode-markers.unit-kg")["expected"]["asciimath"]

    expect(asciimath["output"]).to eq("ustd(1.2, 0.1) rm(k) g")
    expect(asciimath["lossless"]).to be(false)
    expect(asciimath["loss"]).to start_with("reads back as 3 node(s)")
  end

  it "writes one-letter UnicodeMath unit symbols back as unitsml" do
    expect(find("unicode-markers.unit-g")["expected"]["asciimath"]["output"])
      .to eq('uexp(100.02147, 0.00079, 2, "unitsml(g)")')
    expect(
      find("unicode-markers.unit-m-per-s")["expected"]["asciimath"]["output"],
    ).to eq('ustd(1.2, 0.1, "unitsml(m*s^-1)")')
  end

  it "writes the shifted numbers of a shared exponent" do
    expect(
      find("asciimath-shared-exponent.standard")["expected"]["asciimath"],
    ).to eq("output" => "ustd(38500, 2300)", "lossless" => true)
  end

  it "records refusals for invalid calls and decimal commas" do
    %w[asciimath-invalid.zero-k asciimath-invalid.reversed-interval
       asciimath-locale.fr-comma asciimath-locale.fr-comma-pair].each do |id|
      expect(RoundtripCasesSpecData.refused?(find(id))).to be(true), id
    end
  end

  it "pins the exact decimal text of the model" do
    model = find("asciimath-standard.absolute")["model"]
    fields = model["fields"].to_h

    expect(model["node"]).to eq("Plurimath::Math::Function::Uncertainty")
    expect(fields["value"]["fields"].first).to eq(["value", { "str" => "1.230" }])
    expect(fields["magnitude"]["fields"].first)
      .to eq(["value", { "str" => "0.004" }])
    expect(fields["category"]).to eq("sym" => "standard")
  end

  it "leaves the model out when a field has no declared encoding" do
    expect(find("unicode-markers.unit-kg")).not_to have_key("model")
  end
end
