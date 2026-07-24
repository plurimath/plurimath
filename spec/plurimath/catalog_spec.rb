require "spec_helper"

RSpec.describe Plurimath::Catalog do
  it "enumerates exactly the documented classes, sorted by catalog name" do
    # Grouped by declaring arity base (class hierarchy), not by catalog type:
    # Menclose subclasses BinaryFunction but renders as unary (its catalog type
    # is asserted below); the FontStyle subtree and the two page-less extras are
    # listed separately.
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
    names = described_class.classes.map(&:catalog_name)
    expected = ternary + binary + font_styles + unary + table + nary + extras
    expect(names).to eq(expected.sort)
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
        expect(entry["type"]).not_to be_empty
        expect(entry["reference"]).to start_with("http")
      end
    end
  end

  it "renders each example from one shared formula without mutating it across formats" do
    formats = %i[asciimath latex mathml omml]
    described_class.classes.each do |klass|
      shared = klass.example_formula
      # Render every format off the SAME object TWICE, in sequence, so a
      # mutation surfaces either as a later format diverging from a fresh
      # render or as a format's own second pass diverging from its first.
      first_pass = formats.to_h do |format|
        [format, shared.public_send("to_#{format}")]
      end
      second_pass = formats.to_h do |format|
        [format, shared.public_send("to_#{format}")]
      end
      aggregate_failures(klass.catalog_name) do
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

  it "builds full entries for representative classes end to end" do
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
end
