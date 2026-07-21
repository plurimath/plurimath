require "spec_helper"

RSpec.describe Plurimath::Catalog do
  it "enumerates the documented ternary functions in a stable, sorted order" do
    expected = %w[
      fenced int limits multiscript oint powerbase prod rule sum underover
    ]
    expect(described_class.classes.map(&:catalog_name)).to eq(expected)
  end

  it "renders every documented example across all four formats without error" do
    described_class.classes.each do |klass|
      formula = klass.example_formula
      aggregate_failures(klass.catalog_name) do
        expect { formula.to_asciimath }.not_to raise_error
        expect { formula.to_latex }.not_to raise_error
        expect { formula.to_mathml }.not_to raise_error
        expect { formula.to_omml }.not_to raise_error
      end
    end
  end

  it "exposes every metadata and rendering key in each catalog entry" do
    keys = %w[name type description reference asciimath latexmath mathml omml]
    described_class.entries.each do |entry|
      aggregate_failures(entry["name"]) do
        expect(entry.keys).to match_array(keys)
        keys.each { |key| expect(entry[key]).not_to be_nil }
        expect(entry["type"]).to eq("ternary")
        expect(entry["reference"]).to start_with("http")
      end
    end
  end

  it "renders each example from one shared formula without mutating it across formats" do
    described_class.classes.each do |klass|
      shared = klass.example_formula
      # Render all four formats off the SAME object, in sequence.
      sequential = {
        asciimath: shared.to_asciimath,
        latex: shared.to_latex,
        mathml: shared.to_mathml,
        omml: shared.to_omml,
      }
      aggregate_failures(klass.catalog_name) do
        # A fresh formula rendered to one format must match the shared one; a
        # divergence would mean an earlier render mutated the shared AST.
        sequential.each do |format, shared_output|
          fresh_output = klass.example_formula.public_send("to_#{format}")
          expect(shared_output).to eq(fresh_output)
        end
      end
    end
  end

  it "builds a full entry for a representative class end to end" do
    entry = Plurimath::Math::Function::Sum.catalog_entry

    expect(entry["name"]).to eq("sum")
    expect(entry["type"]).to eq("ternary")
    expect(entry["asciimath"]).to eq("sum_(x)^(y) z")
    expect(entry["latexmath"]).to eq("\\sum_{x}^{y} z")
  end
end
