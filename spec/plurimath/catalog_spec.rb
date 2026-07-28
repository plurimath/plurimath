require "spec_helper"

RSpec.describe Plurimath::Catalog do
  # Independently gather a class's full subtree (descendants is direct-only).
  def symbol_subtree(klass)
    Array(klass.descendants).flat_map { |d| [d, *symbol_subtree(d)] }
  end

  it "enumerates exactly the documented functions, sorted by catalog name" do
    # Grouped by declaring arity base (class hierarchy), not by catalog type:
    # Menclose subclasses BinaryFunction but renders as unary (asserted below);
    # the FontStyle subtree, the Table/Nary bases, and the two page-less extras
    # are listed separately.
    ternary = %w[
      fenced int limits oint powerbase prod rule sum underover
    ]
    binary = %w[
      arg base color frac inf intent lim log menclose mlabeledtr mod over
      overset power root semantics stackrel underset
    ]
    font_styles = %w[
      bold boldfraktur bolditalic boldsansserif boldscript doublestruck fraktur
      italic monospace normal sansserif sansserifbolditalic sansserifitalic
      script
    ]
    unary = %w[
      abs arccos arcsin arctan bar cancel ceil cos cosh cot coth csc csch ddot
      deg det dim dot exp floor gcd glb hat hom ker lcm lg liminf limsup ln
      longdiv lub max mbox merror min msgroup norm obrace phantom scarries sec
      sech sin sinh sqrt substack sup tan tanh text tilde ubrace ul vec
    ]
    # Table and Nary subclass Core directly (not an arity base), so each is
    # enumerated as its own documentable base. The Table base itself is the
    # `table` page; its ten matrix subclasses share the inherited :unary type.
    table = %w[
      align array bmatrix cases eqarray matrix multline pmatrix split table
      vmatrix
    ]
    nary = %w[n-ary]
    # Documented for completeness but with no standalone
    # plurimath.org/functions page; pulled out of their arity groups so this
    # allowlist is explicit. Every other catalogued name maps to a site page.
    extras = %w[multiscript overleftrightarrow]
    functions = described_class.classes
      .reject { |klass| klass.catalog_type == :symbol }
      .map(&:catalog_name)
    expected = ternary + binary + font_styles + unary + table + nary + extras
    expect(functions).to eq(expected.sort)
  end

  it "catalogues the Table and Nary bases in their own right, not only their descendants" do
    names = described_class.classes.map(&:catalog_name)
    expect(names).to include("table", "n-ary")

    nary = Plurimath::Math::Function::Nary
    # Nary derives to "nary", so it overrides the slug to match the site page.
    expect(nary.catalog_name).to eq("n-ary")
    expect(nary.catalog_type).to eq(:binary)

    expect(Plurimath::Math::Function::Table.catalog_name).to eq("table")
    expect(Plurimath::Math::Function::Table.catalog_type).to eq(:unary)
  end

  it "overrides catalog_type to the site's semantic arity for font styles and menclose" do
    type_of = described_class.classes.to_h { |k| [k.catalog_name, k.catalog_type] }
    # Font styles (14) and Menclose subclass BinaryFunction but the site lists
    # them as unary, so each overrides the inherited :binary type.
    unary = %w[
      menclose bold boldfraktur bolditalic boldsansserif boldscript
      doublestruck fraktur italic monospace normal sansserif
      sansserifbolditalic sansserifitalic script
    ]
    # The remaining un-excluded binary-arity classes keep the inherited :binary.
    binary = %w[arg color intent overset semantics underset]
    aggregate_failures do
      unary.each { |name| expect(type_of[name]).to eq(:unary), "#{name} should be unary" }
      binary.each { |name| expect(type_of[name]).to eq(:binary), "#{name} should be binary" }
    end
  end

  it "catalogues every concrete symbol, with the abstract Paren base excluded" do
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

  it "orders cross-type name collisions deterministically by type" do
    # `bar` is both a unary function and a symbol. Names alone don't order
    # them, so classes falls back to catalog type: "symbol" < "unary" puts the
    # symbol first, giving totally-ordered, reproducible output.
    types = described_class.classes
      .select { |klass| klass.catalog_name == "bar" }
      .map(&:catalog_type)
    expect(types).to eq(%i[symbol unary])
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
    formats = %i[asciimath latex mathml omml]
    functions = described_class.classes.reject { |klass| klass.catalog_type == :symbol }
    functions.each do |klass|
      shared = klass.example_formula
      aggregate_failures(klass.catalog_name) do
        # Render every format off the SAME object TWICE, in sequence, so a
        # mutation surfaces either as a later format diverging from a fresh
        # render or as a format's own second pass diverging from its first.
        first_pass = formats.to_h do |format|
          [format, shared.public_send("to_#{format}")]
        end
        second_pass = formats.to_h do |format|
          [format, shared.public_send("to_#{format}")]
        end
        # A fresh formula rendered once is the mutation-free reference; both
        # passes off the shared object must still match it.
        formats.each do |format|
          reference = klass.example_formula.public_send("to_#{format}")
          expect(first_pass[format]).to eq(reference)
          expect(second_pass[format]).to eq(reference)
        end
      end
    end
  end

  it "renders each symbol example from one shared formula without mutating it" do
    formats = %i[asciimath latex mathml omml]
    # SymbolDocumentation#catalog_entry renders all four formats off a single
    # example_formula, so guard the same no-mutation property the functions
    # get. A representative spread (a letter, a relation, an n-ary operator and
    # a nested-namespace delimiter) stands in for the ~1,459 symbols the suite
    # renders in full elsewhere.
    representative_names = %w[alpha leq bigwedge lround]
    representative = described_class.classes.select do |klass|
      klass.catalog_type == :symbol &&
        representative_names.include?(klass.catalog_name)
    end
    expect(representative.size).to eq(representative_names.size)
    representative.each do |klass|
      shared = klass.example_formula
      first_pass = formats.to_h { |f| [f, shared.public_send("to_#{f}")] }
      second_pass = formats.to_h { |f| [f, shared.public_send("to_#{f}")] }
      aggregate_failures(klass.catalog_name) do
        formats.each do |format|
          reference = klass.example_formula.public_send("to_#{format}")
          expect(first_pass[format]).to eq(reference)
          expect(second_pass[format]).to eq(reference)
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
