require "spec_helper"

RSpec.describe Plurimath::Catalog do
  # Independently gather a class's full subtree (descendants is direct-only).
  def symbol_subtree(klass)
    Array(klass.descendants).flat_map { |d| [d, *symbol_subtree(d)] }
  end

  it "enumerates exactly the documented functions, sorted by catalog name" do
    ternary = %w[
      fenced int limits multiscript oint powerbase prod rule sum underover
    ]
    binary = %w[
      base frac inf lim log mod over power root stackrel
    ]
    unary = %w[
      abs arccos arcsin arctan bar ceil cos cosh cot coth csc csch ddot deg det
      dim dot exp floor gcd hat hom ker lg liminf limsup ln lub max min
      obrace overleftrightarrow sec sech sin sinh sqrt sup tan tanh tilde ubrace
      ul vec
    ]
    functions = described_class.classes
      .reject { |klass| klass.catalog_type == :symbol }
      .map(&:catalog_name)
    expect(functions).to eq((ternary + binary + unary).sort)
  end

  it "catalogs every concrete symbol, with the abstract Paren base excluded" do
    symbols = described_class.classes.select { |klass| klass.catalog_type == :symbol }
    # Every class below Symbols::Symbol (recursively — nested families such as
    # the Paren delimiters included) except the abstract Paren base, which
    # renders nothing. Symbol is not among its own descendants.
    paren = Plurimath::Math::Symbols::Paren
    expected = symbol_subtree(Plurimath::Math::Symbols::Symbol) - [paren]
    expect(symbols).to match_array(expected)

    names = symbols.map(&:catalog_name)
    expect(names).to eq(names.uniq)
    expect(names).to include("alpha", "leq", "bigwedge", "lround")
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

  it "exposes the right keys for each entry type" do
    symbol_keys = %w[name type asciimath latexmath mathml omml]
    function_keys = symbol_keys + %w[description reference]
    described_class.entries.each do |entry|
      aggregate_failures(entry["name"]) do
        symbol_keys.each { |key| expect(entry[key]).not_to be_nil }
        if entry["type"] == "symbol"
          expect(entry.keys).to match_array(symbol_keys)
        else
          expect(entry.keys).to match_array(function_keys)
          expect(entry["description"]).not_to be_nil
          expect(entry["reference"]).to start_with("http")
        end
      end
    end
  end

  it "renders each function example from one shared formula without mutating it" do
    functions = described_class.classes.reject { |klass| klass.catalog_type == :symbol }
    functions.each do |klass|
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

  it "builds full entries for representative functions end to end" do
    sum = Plurimath::Math::Function::Sum.catalog_entry
    expect(sum["name"]).to eq("sum")
    expect(sum["type"]).to eq("ternary")
    expect(sum["asciimath"]).to eq("sum_(x)^(y) z")
    expect(sum["latexmath"]).to eq("\\sum_{x}^{y} z")

    frac = Plurimath::Math::Function::Frac.catalog_entry
    expect(frac["name"]).to eq("frac")
    expect(frac["type"]).to eq("binary")
    expect(frac["asciimath"]).to eq("frac(x)(y)")
    expect(frac["latexmath"]).to eq("\\frac{x}{y}")

    sin = Plurimath::Math::Function::Sin.catalog_entry
    expect(sin["name"]).to eq("sin")
    expect(sin["type"]).to eq("unary")
    expect(sin["asciimath"]).to eq("sinx")
    expect(sin["latexmath"]).to eq("\\sin{x}")
  end

  it "builds a lean entry for a representative symbol end to end" do
    alpha = Plurimath::Math::Symbols::Alpha.catalog_entry
    expect(alpha["name"]).to eq("alpha")
    expect(alpha["type"]).to eq("symbol")
    expect(alpha["asciimath"]).to eq("alpha")
    expect(alpha["latexmath"]).to eq("\\alpha")
    expect(alpha).not_to have_key("description")
  end
end
