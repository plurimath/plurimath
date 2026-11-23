# frozen_string_literal: true

require "spec_helper"
require_relative "../../scripts/replay_stage_roundtrips"
require_relative "../support/roundtrip_parse_cache"

RSpec.describe ReplayStageRoundtrips, engine_loop: :always do
  include RoundtripParseCache

  before { memoize_roundtrip_parses }

  let(:formula) { Plurimath::Math.parse("2 + 3", :asciimath) }
  let(:legacy_targets) { %w[asciimath unicode mathml omml] }

  def recorded_case(targets)
    { "source" => { "language" => "asciimath", "input" => "2 + 3" },
      "expected" => targets.to_h do |name|
        [name, RoundtripCases.target(formula, name, {})]
      end }
  end

  it "replays the four targets of existing pinned generations" do
    expect(described_class.differences(recorded_case(legacy_targets))).to be_empty
  end

  it "replays OpenMath when a later generation includes it" do
    expect(described_class.differences(recorded_case(legacy_targets + ["openmath"]))).to be_empty
  end

  it "checks rather than ignores an incorrect OpenMath output" do
    entry = recorded_case(legacy_targets + ["openmath"])
    entry["expected"]["openmath"]["output"] = "wrong"
    expect(described_class.differences(entry)).to include("openmath: output differs")
  end

  it "replays equivalent self-closing and expanded OpenMath elements" do
    output = '<OMOBJ xmlns="http://www.openmath.org/OpenMath" version="2.0"><OMA><OMS cd="arith1" name="plus"/><OMI>2</OMI><OMI>3</OMI></OMA></OMOBJ>'
    expanded = output.sub('<OMS cd="arith1" name="plus"/>', '<OMS cd="arith1" name="plus"></OMS>')
    [output, expanded].each do |expected|
      entry = recorded_case(legacy_targets + ["openmath"])
      entry["expected"]["openmath"]["output"] = expected
      expect(described_class.differences(entry)).to be_empty
    end
  end

  it "still checks OpenMath names, attributes, text and child order" do
    entry = recorded_case(legacy_targets + ["openmath"])
    output = entry["expected"]["openmath"]["output"]
    [output.sub('name="plus"', 'name="minus"'),
     output.sub('cd="arith1"', 'cd="custom"'),
     output.sub('>2</OMI>', '>4</OMI>'),
     output.sub('<OMI>2</OMI><OMI>3</OMI>', '<OMI>3</OMI><OMI>2</OMI>'),
     output.sub('http://www.openmath.org/OpenMath', 'https://example.org/other')].each do |different|
      entry["expected"]["openmath"]["output"] = different
      expect(described_class.differences(entry)).to include("openmath: output differs")
    end
  end

  it "still checks the loss flag after matching equivalent OpenMath XML" do
    entry = recorded_case(legacy_targets + ["openmath"])
    entry["expected"]["openmath"]["output"] = '<OMOBJ xmlns="http://www.openmath.org/OpenMath" version="2.0"><OMA><OMS cd="arith1" name="plus"></OMS><OMI>2</OMI><OMI>3</OMI></OMA></OMOBJ>'
    entry["expected"]["openmath"]["lossless"] = false
    expect(described_class.differences(entry)).to include(a_string_starting_with("openmath:"))
  end

  it "keeps byte comparison for other XML targets" do
    entry = recorded_case(legacy_targets)
    entry["expected"]["mathml"]["output"] += "\n"
    expect(described_class.differences(entry)).to include("mathml: output differs")
  end

  it "replays all six presentation targets and OpenMath" do
    entry = recorded_case(legacy_targets + %w[latex html openmath])
    expect(described_class.differences(entry)).to be_empty
    entry["expected"]["html"]["output"] = "wrong"
    expect(described_class.differences(entry)).to include("html: output differs")
  end

  it "checks the measured LaTeX and HTML losses for uncertainty" do
    input = '"ustd(1.230, 0.004)"'
    uncertainty = Plurimath::Math.parse(input, :asciimath)
    _, expected = RoundtripCases.expected(input, "asciimath", {})
    presentation = {
      "latex" => { "output" => "1.230(0.004)", "lossless" => false,
                   "loss" => "reads back as 2 node(s) (Number, Fenced) instead of 1 node(s) (Uncertainty)" },
      "html" => { "output" => "1.230(0.004)", "lossless" => false,
                  "loss" => "node 0: Plurimath::Math::Function::Uncertainty reads back as Hash" },
    }
    entry = { "source" => { "language" => "asciimath", "input" => input },
              "expected" => expected.merge(presentation) }

    expect(described_class.differences(entry)).to be_empty
    presentation.each do |name, target|
      expect(described_class.target_differences(uncertainty, name, target.merge("lossless" => true), {}))
        .to include(a_string_starting_with("#{name}:"))
      expect(described_class.target_differences(uncertainty, name, target.merge("loss" => "wrong"), {}))
        .to include(a_string_starting_with("#{name}:"))
    end
  end

  it "counts target refusals separately from source refusals" do
    entry = recorded_case(legacy_targets + ["openmath"])
    entry["expected"]["openmath"] = { "refusal" => { "category" => "unsupported_expression" } }
    source_refusal = { "source" => { "language" => "asciimath", "input" => "" },
                       "expected" => { "openmath" => { "refusal" => { "category" => "parse_error" } } } }
    result = described_class.replay([entry, source_refusal])
    expect(result).to include("source_refused" => 1, "target_refused" => 1, "refused" => 2)
    expect(result["differing"]).not_to be_empty
  end

  it "replays explicit target refusals without refusing a valid source" do
    uncertainty = Plurimath::Math.parse('"ustd(1.2,0.1)"', :asciimath)
    target = RoundtripCases.target(uncertainty, "openmath", {})
    expect(target).to include("refusal")
    expect(described_class.target_differences(uncertainty, "openmath", target, {})).to be_empty
    expect(described_class.target_differences(formula, "openmath", target, {}))
      .to include("openmath: refusal differs")
  end

  it "rejects missing required targets and unknown writers" do
    expect(described_class.differences(recorded_case(["asciimath"])))
      .to include("unknown or missing roundtrip targets")
    entry = recorded_case(legacy_targets)
    entry["expected"]["invented"] = {}
    expect(described_class.differences(entry)).to include("unknown or missing roundtrip targets")
  end
end
