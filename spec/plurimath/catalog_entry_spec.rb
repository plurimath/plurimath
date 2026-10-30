require "spec_helper"

RSpec.describe Plurimath::Catalog::Entry do
  let(:formula) { Plurimath::Math::Formula.new([Plurimath::Math::Number.new("1")]) }
  let(:arguments) do
    {
      name: "sample", kind: :function, type: :unary, arity: :unary,
      description: "An example.", reference: "https://example.com/sample",
      formula: formula
    }
  end

  it "preserves each serializer's exact output and exposes availability separately" do
    entry = described_class.build(**arguments)
    described_class::RENDERERS.each do |format, method|
      expect(entry[format]).to eq(formula.public_send(method))
      expect(entry["formats"][format]).to eq("status" => "available", "notes" => [])
    end
  end

  it "supports the symbol contract without function-only metadata" do
    entry = described_class.build(**arguments, kind: :symbol, type: :symbol, arity: nil)
    expect(entry.values_at("kind", "type", "arity")).to eq(["symbol", "symbol", nil])
    expect(entry).not_to have_key("description")
    expect(entry).not_to have_key("reference")
  end

  it "marks an empty serializer result unavailable without changing its bytes" do
    allow(formula).to receive(:to_asciimath).and_return(" \n")
    entry = described_class.build(**arguments)
    expect(entry["asciimath"]).to eq(" \n")
    expect(entry["formats"]["asciimath"]).to eq(
      "status" => "unavailable", "notes" => [described_class::EMPTY_OUTPUT_NOTE],
    )
  end

  it "records a declared limitation while keeping the actual output" do
    limitations = { mathml: { status: :limited, notes: ["A modifier is omitted."] } }
    entry = described_class.build(**arguments, limitations: limitations)
    expect(entry["mathml"]).to eq(formula.to_mathml)
    expect(entry["formats"]["mathml"]).to eq(
      "status" => "limited", "notes" => ["A modifier is omitted."],
    )
  end

  it "allows an unavailable declaration for a nonempty serializer placeholder" do
    limitations = { omml: { status: :unavailable, notes: ["Only a placeholder is emitted."] } }
    entry = described_class.build(**arguments, limitations: limitations)
    expect(entry["omml"]).not_to be_empty
    expect(entry["formats"]["omml"]["status"]).to eq("unavailable")
  end

  it "gives empty output precedence over a declared limited status" do
    allow(formula).to receive(:to_asciimath).and_return("")
    limits = { asciimath: { status: :limited, notes: ["A limitation."] } }
    entry = described_class.build(**arguments, limitations: limits)
    expect(entry["formats"]["asciimath"]["status"]).to eq("unavailable")
    expect(entry["formats"]["asciimath"]["notes"]).to include("A limitation.")
  end

  it "does not mutate declarations or share mutable notes between entries" do
    limits = { mathml: { status: :limited, notes: ["Original"].freeze }.freeze }.freeze
    first = described_class.build(**arguments, limitations: limits)
    first["formats"]["mathml"]["notes"].first.replace("Changed")
    second = described_class.build(**arguments, limitations: limits)
    expect(second["formats"]["mathml"]["notes"]).to eq(["Original"])
    expect(limits[:mathml][:notes]).to eq(["Original"])
  end

  it "rejects malformed declarations instead of silently ignoring them" do
    invalid = [
      nil,
      { latex: { status: :limited, notes: ["Unknown format"] } },
      { mathml: { status: :available, notes: ["Not a limitation"] } },
      { mathml: { status: :limited, notes: [] } },
      { mathml: { status: :limited, notes: [42] } },
      { mathml: { status: :limited, notes: [" "] } },
      { mathml: { status: :limited, notes: ["Reason"], typo: true } },
      { mathml: { status: :limited, "status" => :limited, notes: ["Reason"] } },
      { mathml: { status: :limited, notes: ["Reason"] }, "mathml" => {} },
    ]
    invalid.each do |limits|
      expect { described_class.build(**arguments, limitations: limits) }
        .to raise_error(Plurimath::Catalog::InvalidEntryError)
    end
  end

  it "does not swallow unexpected serializer failures" do
    allow(formula).to receive(:to_mathml).and_raise(RuntimeError, "serializer defect")
    expect { described_class.build(**arguments) }.to raise_error(RuntimeError, "serializer defect")
  end

  it "rejects invalid metadata before invoking the serializers" do
    allow(formula).to receive(:to_asciimath).and_call_original
    expect { described_class.build(**arguments, description: "") }
      .to raise_error(Plurimath::Catalog::InvalidEntryError)
    expect(formula).not_to have_received(:to_asciimath)
  end

  it "discloses flattened elementary layouts and generic labeled-row output" do
    limited_formats = %w[asciimath latexmath omml]
    [Plurimath::Math::Function::Scarries, Plurimath::Math::Function::Msgroup].each do |klass|
      entry = klass.catalog_entry
      limited_formats.each do |format|
        expect(entry.dig("formats", format, "status")).to eq("limited")
        expect(entry.dig("formats", format, "notes")).not_to be_empty
      end
      expect(entry.values_at("asciimath", "latexmath")).to eq(%w[x x])
      expect(entry.dig("formats", "mathml", "status")).to eq("available")
    end
    row = Plurimath::Math::Function::Mlabeledtr.catalog_entry
    expect(row["latexmath"]).to eq('\\mlabeledtr{x}{\\text{1}}')
    expect(row.dig("formats", "latexmath", "status")).to eq("limited")
    expect(row.dig("formats", "asciimath", "status")).to eq("limited")
    expect(row.dig("formats", "omml", "status")).to eq("limited")
    expect(row.dig("formats", "mathml", "status")).to eq("available")
  end

  it "marks real rule placeholders unavailable while retaining their output" do
    entry = Plurimath::Math::Function::Rule.catalog_entry
    expect(entry.dig("formats", "latexmath", "status")).to eq("available")
    %w[asciimath mathml omml].each do |format|
      expect(entry.dig("formats", format, "status")).to eq("unavailable")
      expect(entry.dig("formats", format, "notes")).not_to be_empty
    end
    expect(entry["mathml"]).not_to be_empty
    expect(entry["omml"]).not_to be_empty
  end
end
