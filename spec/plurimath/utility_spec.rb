require "spec_helper"

# Characterization specs (refactor phase A0) for the class methods that remain
# on Plurimath::Utility after the language-utility split. These pin CURRENT
# behavior on main — including known bugs, each marked with a "# quirk:"
# comment — ahead of a strictly behavior-preserving refactor. Do not "fix" an
# expectation here; behavior changes belong in a later, separate PR together
# with the production-code change.
#
# XML helpers note: every example runs twice (Ox and Oga, via the around hook
# in spec_helper). Assertions stick to engine-stable properties: node name,
# attribute values, children, and the string produced by
# Plurimath.xml_engine.dump(..., indent: 2), which is byte-identical across
# engines for these structures. The one genuinely engine-dependent surface
# (namespaced attribute hash keys / [] lookup keys) is asserted per-engine.
RSpec.describe Plurimath::Utility do
  def slice(string)
    Parslet::Slice.new(Parslet::Position.new(string, 0), string)
  end

  # Whitespace-collapsed engine dump; the raw dump (indent: 2) is identical
  # across Ox and Oga, collapsing makes the expectations single-line.
  def dumped(element)
    Plurimath.xml_engine.dump(element, indent: 2).gsub(/\n\s*/, "")
  end

  def oga_engine?
    Plurimath.xml_engine == Plurimath::XmlEngine::Oga
  end

  describe ".symbols_class" do
    it "resolves a known symbol string to its symbol class instance" do
      expect(described_class.symbols_class("+", lang: :mathml))
        .to eq(Plurimath::Math::Symbols::Plus.new)
    end

    it "strips surrounding whitespace before the lookup" do
      expect(described_class.symbols_class(" + ", lang: :mathml))
        .to eq(Plurimath::Math::Symbols::Plus.new)
    end

    it "wraps an unknown string in Symbols::Symbol with the original value" do
      expect(described_class.symbols_class("zzunknownzz", lang: :mathml))
        .to eq(Plurimath::Math::Symbols::Symbol.new("zzunknownzz"))
    end

    it "passes a non-String object through untouched" do
      number = Plurimath::Math::Number.new("1")

      expect(described_class.symbols_class(number, lang: :mathml)).to be(number)
    end

    it "passes nil through untouched" do
      expect(described_class.symbols_class(nil, lang: :mathml)).to be_nil
    end

    context "with table: true, lang: :latex (latex_table_curly_paren)" do
      it "maps \"{\" to Paren::Lcurly" do
        expect(described_class.symbols_class("{", lang: :latex, table: true))
          .to eq(Plurimath::Math::Symbols::Paren::Lcurly.new)
      end

      it "maps \"}\" to Paren::Rcurly" do
        expect(described_class.symbols_class("}", lang: :latex, table: true))
          .to eq(Plurimath::Math::Symbols::Paren::Rcurly.new)
      end

      it "falls back to the normal latex lookup for other paren strings" do
        expect(described_class.symbols_class("(", lang: :latex, table: true))
          .to eq(Plurimath::Math::Symbols::Paren::Lround.new)
      end

      it "falls back to Symbols::Symbol for non-paren strings" do
        expect(described_class.symbols_class("x", lang: :latex, table: true))
          .to eq(Plurimath::Math::Symbols::Symbol.new("x"))
      end
    end

    it "ignores table: true for non-latex langs and uses the normal lookup" do
      expect(described_class.symbols_class("{", lang: :mathml, table: true))
        .to eq(Plurimath::Math::Symbols::Paren::Lcurly.new)
    end
  end

  describe ".get_class" do
    it "resolves \"sin\" to the Function::Sin class object" do
      expect(described_class.get_class("sin")).to be(Plurimath::Math::Function::Sin)
    end

    it "resolves \"frac\" to the Function::Frac class object" do
      expect(described_class.get_class("frac")).to be(Plurimath::Math::Function::Frac)
    end

    it "resolves \"lim\" to the Function::Lim class object" do
      expect(described_class.get_class("lim")).to be(Plurimath::Math::Function::Lim)
    end

    it "capitalize-joins underscored names" do
      expect(described_class.get_class("power_base"))
        .to be(Plurimath::Math::Function::PowerBase)
    end

    it "accepts symbols via to_s" do
      expect(described_class.get_class(:sum)).to be(Plurimath::Math::Function::Sum)
    end

    it "raises NameError for names without a Function class" do
      expect { described_class.get_class("nope_missing") }.to raise_error(NameError)
    end
  end

  describe ".symbols_hash" do
    it "returns a Hash mapping input strings to symbol class objects" do
      hash = described_class.symbols_hash(:mathml)

      expect(hash).to be_a(Hash)
      expect(hash["+"]).to be(Plurimath::Math::Symbols::Plus)
    end

    it "builds the same mapping for other langs" do
      expect(described_class.symbols_hash(:omml)["+"])
        .to be(Plurimath::Math::Symbols::Plus)
    end

    it "memoizes per lang, returning the identical Hash object" do
      first_call = described_class.symbols_hash(:mathml)
      second_call = described_class.symbols_hash(:mathml)

      expect(first_call).to be(second_call)
    end

    it "orders keys by descending string length" do
      keys = described_class.symbols_hash(:mathml).keys

      expect(keys.each_cons(2).all? { |a, b| a.length >= b.length }).to be(true)
    end

    it "does not contain function words like \"sin\"" do
      expect(described_class.symbols_hash(:mathml)).not_to have_key("sin")
    end

    it "returns nil for unknown keys" do
      expect(described_class.symbols_hash(:mathml)["zzunknownzz"]).to be_nil
    end
  end

  describe ".filter_values" do
    it "unwraps a single-element array to its (identical) element" do
      number = Plurimath::Math::Number.new("7")

      expect(described_class.filter_values([number])).to be(number)
    end

    it "wraps a multi-element array in a Formula" do
      one = Plurimath::Math::Number.new("1")
      two = Plurimath::Math::Number.new("2")

      expect(described_class.filter_values([one, two]))
        .to eq(Plurimath::Math::Formula.new([one, two]))
    end

    it "returns the multi-element array itself with new_formula: false" do
      one = Plurimath::Math::Number.new("1")
      two = Plurimath::Math::Number.new("2")

      expect(described_class.filter_values([one, two], new_formula: false))
        .to eq([one, two])
    end

    it "flattens nested arrays and compacts nils before unwrapping" do
      number = Plurimath::Math::Number.new("1")

      expect(described_class.filter_values([[number], nil])).to be(number)
    end

    it "returns nil for an empty array" do
      expect(described_class.filter_values([])).to be_nil
    end

    it "passes non-Array, non-Formula input through untouched" do
      number = Plurimath::Math::Number.new("1")

      expect(described_class.filter_values(number)).to be(number)
      expect(described_class.filter_values("abc")).to eq("abc")
      expect(described_class.filter_values(nil)).to be_nil
    end

    it "rewraps a multi-value Formula's value in a new Formula" do
      one = Plurimath::Math::Number.new("1")
      two = Plurimath::Math::Number.new("2")
      formula = Plurimath::Math::Formula.new([one, two])

      result = described_class.filter_values(formula)

      expect(result).to eq(Plurimath::Math::Formula.new([one, two]))
      expect(result).not_to be(formula)
    end

    it "unwraps a single-value Formula to its element" do
      number = Plurimath::Math::Number.new("1")
      formula = Plurimath::Math::Formula.new([number])

      expect(described_class.filter_values(formula)).to be(number)
    end
  end

  describe ".string_to_html_entity" do
    it "encodes a unicode character hexadecimally" do
      expect(described_class.string_to_html_entity("∑")).to eq("&#x2211;")
    end

    it "leaves plain ASCII words unchanged" do
      expect(described_class.string_to_html_entity("bar")).to eq("bar")
      expect(described_class.string_to_html_entity("abc")).to eq("abc")
      expect(described_class.string_to_html_entity("+")).to eq("+")
    end

    # quirk: an already-encoded entity is encoded again — the leading "&"
    # becomes "&#x26;", producing a mangled double-encoded string.
    it "double-encodes an already-encoded entity string" do
      expect(described_class.string_to_html_entity("&#x2211;"))
        .to eq("&#x26;#x2211;")
    end

    it "handles frozen strings without raising" do
      expect(described_class.string_to_html_entity("∑".freeze)).to eq("&#x2211;")
    end
  end

  describe ".html_entity_to_unicode" do
    it "decodes a hexadecimal entity to its unicode character" do
      expect(described_class.html_entity_to_unicode("&#x2211;")).to eq("∑")
    end

    it "decodes named entities" do
      expect(described_class.html_entity_to_unicode("&sum;")).to eq("∑")
    end

    it "returns strings without \"&\" untouched (same object)" do
      string = "bar"

      expect(described_class.html_entity_to_unicode(string)).to be(string)
    end

    it "leaves a bare ampersand as-is" do
      expect(described_class.html_entity_to_unicode("a & b")).to eq("a & b")
    end

    it "returns nil for nil" do
      expect(described_class.html_entity_to_unicode(nil)).to be_nil
    end

    it "round-trips through string_to_html_entity" do
      encoded = described_class.string_to_html_entity("∑")

      expect(described_class.html_entity_to_unicode(encoded)).to eq("∑")
    end
  end

  describe ".symbol_object" do
    # quirk: "ℒ" and "ℛ" are remapped to the asciimath open/close table
    # tokens "{:" and ":}", which have no symbol class for lang: :omml, so
    # they end up as plain Symbols with those literal values.
    it "remaps \"ℒ\" to a Symbol with value \"{:\"" do
      expect(described_class.symbol_object("ℒ", lang: :omml))
        .to eq(Plurimath::Math::Symbols::Symbol.new("{:"))
    end

    it "remaps \"ℛ\" to a Symbol with value \":}\"" do
      expect(described_class.symbol_object("ℛ", lang: :omml))
        .to eq(Plurimath::Math::Symbols::Symbol.new(":}"))
    end

    it "remaps \"ᑕ\" to Paren::Langle via the &#x2329; entity" do
      expect(described_class.symbol_object("ᑕ", lang: :omml))
        .to eq(Plurimath::Math::Symbols::Paren::Langle.new)
    end

    it "remaps \"ᑐ\" to Paren::Rangle via the &#x232a; entity" do
      expect(described_class.symbol_object("ᑐ", lang: :omml))
        .to eq(Plurimath::Math::Symbols::Paren::Rangle.new)
    end

    it "resolves other values through symbols_class" do
      expect(described_class.symbol_object("+", lang: :omml))
        .to eq(Plurimath::Math::Symbols::Plus.new)
    end

    # Mirrors the OMML call site: symbol_object(string_to_html_entity(value)).
    it "resolves an entity-encoded character to its symbol class" do
      encoded = described_class.string_to_html_entity("∑")

      expect(described_class.symbol_object(encoded, lang: :omml))
        .to eq(Plurimath::Math::Symbols::Sum.new)
    end

    it "wraps unknown values in Symbols::Symbol" do
      expect(described_class.symbol_object("zzz", lang: :omml))
        .to eq(Plurimath::Math::Symbols::Symbol.new("zzz"))
    end
  end

  describe ".get_table_class" do
    it "resolves environment names to Table subclasses" do
      {
        "matrix" => Plurimath::Math::Function::Table::Matrix,
        "pmatrix" => Plurimath::Math::Function::Table::Pmatrix,
        "bmatrix" => Plurimath::Math::Function::Table::Bmatrix,
        "vmatrix" => Plurimath::Math::Function::Table::Vmatrix,
        "array" => Plurimath::Math::Function::Table::Array,
        "align" => Plurimath::Math::Function::Table::Align,
        "split" => Plurimath::Math::Function::Table::Split,
        "multline" => Plurimath::Math::Function::Table::Multline,
        "cases" => Plurimath::Math::Function::Table::Cases,
        "eqarray" => Plurimath::Math::Function::Table::Eqarray,
      }.each do |name, klass|
        expect(described_class.get_table_class(name)).to eq(klass)
      end
    end

    it "accepts Parslet::Slice input" do
      expect(described_class.get_table_class(slice("matrix"))).to eq(
        Plurimath::Math::Function::Table::Matrix,
      )
    end

    it "raises NameError for an unknown environment" do
      expect { described_class.get_table_class("nope") }.to raise_error(NameError)
    end
  end

  describe ".parens_hash" do
    it "maps asciimath paren tokens to Paren classes" do
      hash = described_class.parens_hash(:asciimath)

      expect(hash).to be_a(Hash)
      expect(hash["("]).to eq(Plurimath::Math::Symbols::Paren::Lround)
      expect(hash[")"]).to eq(Plurimath::Math::Symbols::Paren::Rround)
      expect(hash["["]).to eq(Plurimath::Math::Symbols::Paren::Lsquare)
      expect(hash["|"]).to eq(Plurimath::Math::Symbols::Paren::Vert)
      expect(hash["{:"]).to eq(Plurimath::Math::Symbols::Paren::OpenParen)
    end

    it "sorts keys by descending length" do
      keys = described_class.parens_hash(:asciimath).keys

      expect(keys.each_cons(2).all? { |a, b| a.length >= b.length }).to be(true)
    end

    # quirk: the per-language memo means skipables are only honored on the
    # first build — later calls return the memoized hash unchanged.
    it "ignores skipables once the language table is memoized" do
      first = described_class.parens_hash(:asciimath)
      second = described_class.parens_hash(:asciimath, skipables: ["lround"])

      expect(second).to be(first)
      expect(second["("]).to eq(Plurimath::Math::Symbols::Paren::Lround)
    end

    it "omits skipable paren classes when building a language table" do
      # Memo plumbing: force a fresh :latex build so the skipables branch is
      # exercised deterministically, then restore the prior memo entry.
      described_class.parens_hash(:asciimath)
      memo = described_class.class_variable_get(:@@parens)
      original = memo.delete(:latex)
      begin
        built = described_class.parens_hash(:latex, skipables: ["lcurly"])

        expect(built.values).not_to include(Plurimath::Math::Symbols::Paren::Lcurly)
        expect(built).not_to have_key("\\{")
        expect(built["("]).to eq(Plurimath::Math::Symbols::Paren::Lround)
      ensure
        # Restore the exact prior memo state: drop the entry this example built,
        # then put back the original only if there was one. Leaving a freshly
        # memoized :latex entry behind would leak state across examples.
        memo.delete(:latex)
        memo[:latex] = original if original
      end
    end

    it "includes every paren class when built without skipables" do
      described_class.parens_hash(:asciimath)
      memo = described_class.class_variable_get(:@@parens)
      original = memo.delete(:latex)
      begin
        built = described_class.parens_hash(:latex)

        expect(built["\\{"]).to eq(Plurimath::Math::Symbols::Paren::Lcurly)
      ensure
        # Never leave the skipables-free build memoized: production builds
        # :latex with skipables ["lcurly"] (Latex::Constants).
        memo.delete(:latex)
        memo[:latex] = original if original
      end
    end

    it "returns an empty hash for a language with no paren inputs" do
      expect(described_class.parens_hash(:no_such_language)).to eq({})
    end
  end

  describe ".symbol_value" do
    it "matches Comma objects when the value contains a comma" do
      expect(described_class.symbol_value(Plurimath::Math::Symbols::Comma.new, ",")).to be(true)
    end

    # quirk: any value merely CONTAINING "," matches a Comma object, the value
    # is not compared to the symbol at all
    it "matches Comma objects for any value containing a comma" do
      expect(described_class.symbol_value(Plurimath::Math::Symbols::Comma.new, "a,b")).to be(true)
    end

    it "matches Minus objects when the value contains a minus" do
      expect(described_class.symbol_value(Plurimath::Math::Symbols::Minus.new, "-")).to be(true)
    end

    it "matches Paren::Vert objects when the value contains a pipe" do
      expect(described_class.symbol_value(Plurimath::Math::Symbols::Paren::Vert.new, "|")).to be(true)
    end

    it "matches generic Symbol objects whose value contains the string" do
      expect(described_class.symbol_value(Plurimath::Math::Symbols::Symbol.new("|"), "|")).to be(true)
    end

    # quirk: substring match, not equality ("ab" contains "b")
    it "matches generic Symbol objects by substring inclusion" do
      expect(described_class.symbol_value(Plurimath::Math::Symbols::Symbol.new("ab"), "b")).to be(true)
    end

    it "matches Linebreak objects against the literal \\\\ value" do
      expect(described_class.symbol_value(Plurimath::Math::Function::Linebreak.new, "\\\\")).to be(true)
    end

    it "returns false for non-symbol objects" do
      expect(described_class.symbol_value(Plurimath::Math::Number.new("1"), ",")).to be(false)
    end

    it "returns false for a nil object" do
      expect(described_class.symbol_value(nil, "|")).to be(false)
    end

    it "returns false when the symbol value does not contain the string" do
      expect(described_class.symbol_value(Plurimath::Math::Symbols::Symbol.new("x"), "y")).to be(false)
    end

    it "returns false for a Symbol whose value is nil" do
      expect(described_class.symbol_value(Plurimath::Math::Symbols::Symbol.new, "x")).to be(false)
    end

    # quirk: nil value crashes on String#include?(nil) once a Symbol object
    # reaches the value-inclusion branch
    it "raises TypeError for a Symbol object and nil value" do
      expect { described_class.symbol_value(Plurimath::Math::Symbols::Symbol.new("a"), nil) }
        .to raise_error(TypeError)
    end
  end

  describe ".table_separator" do
    def build_tr
      Plurimath::Math::Function::Tr.new(
        [
          Plurimath::Math::Function::Td.new([Plurimath::Math::Number.new("1")]),
          Plurimath::Math::Function::Td.new([Plurimath::Math::Number.new("2")]),
        ],
      )
    end

    def vert_td
      Plurimath::Math::Function::Td.new([Plurimath::Math::Symbols::Paren::Vert.new])
    end

    it "inserts a vert Td AFTER the matching column for the default solid symbol" do
      tr = build_tr
      described_class.table_separator(["solid", "none"], [tr])

      expected = Plurimath::Math::Function::Tr.new(
        [
          Plurimath::Math::Function::Td.new([Plurimath::Math::Number.new("1")]),
          vert_td,
          Plurimath::Math::Function::Td.new([Plurimath::Math::Number.new("2")]),
        ],
      )
      expect(tr).to eq(expected)
    end

    it "inserts a vert Td AT the matching column index for the | symbol" do
      tr = build_tr
      described_class.table_separator(["|"], [tr], symbol: "|")

      expected = Plurimath::Math::Function::Tr.new(
        [
          vert_td,
          Plurimath::Math::Function::Td.new([Plurimath::Math::Number.new("1")]),
          Plurimath::Math::Function::Td.new([Plurimath::Math::Number.new("2")]),
        ],
      )
      expect(tr).to eq(expected)
    end

    it "mutates and returns the same value array" do
      tr = build_tr
      value = [tr]
      result = described_class.table_separator(["solid"], value)

      expect(result).to be(value)
      expect(result.first).to be(tr)
    end

    it "returns the value unchanged for a nil separator" do
      tr = build_tr
      expect(described_class.table_separator(nil, [tr])).to eq([build_tr])
      expect(tr.parameter_one.length).to eq(2)
    end

    it "returns the value unchanged when no separator entry matches the symbol" do
      tr = build_tr
      described_class.table_separator(["none"], [tr])
      expect(tr).to eq(build_tr)
    end
  end

  describe ".primes_constants" do
    it "returns the prefixed primes merged with sprime" do
      expect(described_class.primes_constants).to eq(
        pppprime: "&#x2057;",
        ppprime: "&#x2034;",
        pprime: "&#x2033;",
        prime: "&#x2032;",
        sprime: "&#x27;",
      )
    end

    it "returns a fresh unfrozen hash on every call" do
      first = described_class.primes_constants
      second = described_class.primes_constants
      expect(first).not_to be(second)
      expect(first).not_to be_frozen
    end
  end

  describe ".hexcode_in_input" do
    it "returns the first &#x...; entry of the symbol's unicodemath input" do
      expect(described_class.hexcode_in_input(Plurimath::Math::Symbols::Comma.new)).to eq("&#x2c;")
      expect(described_class.hexcode_in_input(Plurimath::Math::Symbols::Prime.new)).to eq("&#x2032;")
      expect(described_class.hexcode_in_input(Plurimath::Math::Symbols::Alpha.new)).to eq("&#x3b1;")
    end

    it "returns nil when the unicodemath input has no hex entity entry" do
      # Bar's unicodemath INPUT is [["¯"]] — no &#x..; entry
      expect(described_class.hexcode_in_input(Plurimath::Math::Symbols::Bar.new)).to be_nil
    end

    it "returns nil when the symbol has no unicodemath input at all" do
      # the Paren base class has INPUT == {}
      expect(described_class.hexcode_in_input(Plurimath::Math::Symbols::Paren.new)).to be_nil
    end
  end

  describe ".ox_element" do
    it "builds an element with the given name and no attributes or children" do
      element = described_class.ox_element("mi")
      expect(element.name).to eq("mi")
      expect(element.attributes).to eq({})
      expect(element.nodes).to eq([])
      expect(dumped(element)).to eq("<mi/>")
    end

    it "prefixes the name with the namespace" do
      element = described_class.ox_element("mo", namespace: "m")
      expect(element.name).to eq("m:mo")
      expect(dumped(element)).to eq("<m:mo/>")
    end

    it "sets plain attributes readable via #attributes and #[]" do
      element = described_class.ox_element(
        "mstyle", attributes: { mathvariant: "bold", displaystyle: "true" }
      )
      expect(element.attributes).to eq("mathvariant" => "bold", "displaystyle" => "true")
      expect(element["mathvariant"]).to eq("bold")
      expect(dumped(element)).to eq('<mstyle mathvariant="bold" displaystyle="true"/>')
    end

    it "serializes namespaced attributes identically on both engines" do
      element = described_class.ox_element(
        "naryPr", namespace: "m", attributes: { "m:val": "1" }
      )
      expect(dumped(element)).to eq('<m:naryPr m:val="1"/>')
      # engine-stable composite lookup: exactly one of the two keys hits
      expect(element["m:val"] || element["val"]).to eq("1")
    end

    # quirk: the in-memory attribute key for namespaced attributes is
    # engine-dependent — Ox keeps the "m:" prefix, Oga strips it (and its []
    # only answers to the stripped name). Serialization is identical.
    it "exposes namespaced attribute hash keys differently per engine" do
      element = described_class.ox_element(
        "naryPr", namespace: "m", attributes: { "m:val": "1" }
      )
      if oga_engine?
        expect(element.attributes).to eq("val" => "1")
        expect(element["val"]).to eq("1")
        expect(element["m:val"]).to be_nil
      else
        expect(element.attributes).to eq("m:val" => "1")
        expect(element["m:val"]).to eq("1")
        expect(element["val"]).to be_nil
      end
    end

    it "decodes HTML entities in attribute values to unicode" do
      element = described_class.ox_element(
        "chr", namespace: "m", attributes: { "m:val": "&#x2211;" }
      )
      expect(dumped(element)).to eq('<m:chr m:val="∑"/>')
      expect(element["m:val"] || element["val"]).to eq("∑")
    end

    it "accepts the default empty-array attributes" do
      element = described_class.ox_element("mrow", attributes: [])
      expect(element.attributes).to eq({})
      expect(dumped(element)).to eq("<mrow/>")
    end
  end

  describe ".update_nodes" do
    it "appends nodes in order and returns the same element" do
      row = described_class.ox_element("mrow")
      mi = described_class.ox_element("mi") << "x"
      mo = described_class.ox_element("mo") << "+"
      mn = described_class.ox_element("mn") << "1"

      result = described_class.update_nodes(row, [mi, mo, mn])
      expect(result).to be(row)
      expect(result.nodes.map(&:name)).to eq(%w[mi mo mn])
      expect(dumped(result)).to eq("<mrow><mi>x</mi><mo>+</mo><mn>1</mn></mrow>")
    end

    it "skips nils and flattens nested arrays recursively" do
      # mirrors Nary#omml_nary_tag, where omml_parameter entries can be nil
      # and nested arrays of elements
      row = described_class.ox_element("mrow")
      mi = described_class.ox_element("mi") << "x"
      mo = described_class.ox_element("mo") << "+"
      mn = described_class.ox_element("mn") << "1"

      described_class.update_nodes(row, [mi, nil, [mo, nil, [mn]], nil])
      expect(row.nodes.map(&:name)).to eq(%w[mi mo mn])
      expect(dumped(row)).to eq("<mrow><mi>x</mi><mo>+</mo><mn>1</mn></mrow>")
    end

    it "returns the element unchanged for a nil node list" do
      row = described_class.update_nodes(described_class.ox_element("mrow"), nil)
      expect(row.name).to eq("mrow")
      expect(row.nodes).to eq([])
    end

    it "returns the element unchanged for a list of nils" do
      row = described_class.update_nodes(described_class.ox_element("mrow"), [nil, nil])
      expect(row.nodes).to eq([])
    end

    it "appends plain strings as text children" do
      element = described_class.update_nodes(
        described_class.ox_element("mtext"), ["hello", nil, "world"]
      )
      expect(element.nodes).to eq(%w[hello world])
      expect(dumped(element)).to eq("<mtext>helloworld</mtext>")
    end
  end

  describe ".rpr_element" do
    it "builds a w:rPr with a Cambria Math w:rFonts child by default" do
      rpr = described_class.rpr_element
      expect(rpr.name).to eq("w:rPr")
      expect(rpr.nodes.map(&:name)).to eq(%w[w:rFonts])
      expect(dumped(rpr)).to eq(
        '<w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr>',
      )
    end

    it "appends a w:i child when wi_tag is true" do
      rpr = described_class.rpr_element(wi_tag: true)
      expect(rpr.nodes.map(&:name)).to eq(%w[w:rFonts w:i])
      expect(dumped(rpr)).to eq(
        '<w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr>',
      )
    end
  end

  describe ".pr_element" do
    it "builds <main>Pr in the given namespace wrapping an rpr element" do
      # mirrors the pervasive Utility.pr_element("ctrl", true, namespace: "m")
      pr = described_class.pr_element("ctrl", true, namespace: "m")
      expect(pr.name).to eq("m:ctrlPr")
      expect(pr.nodes.map(&:name)).to eq(%w[w:rPr])
      expect(dumped(pr)).to eq(
        "<m:ctrlPr>" \
        '<w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr>' \
        "</m:ctrlPr>",
      )
    end

    it "omits the w:i tag when wi_tag is not passed" do
      pr = described_class.pr_element("d", namespace: "m")
      expect(pr.name).to eq("m:dPr")
      expect(dumped(pr)).to eq(
        "<m:dPr>" \
        '<w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr>' \
        "</m:dPr>",
      )
    end

    it "builds an unprefixed tag for the default empty namespace" do
      pr = described_class.pr_element("box")
      expect(pr.name).to eq("boxPr")
    end
  end

  describe ".capitalize" do
    it "camelizes underscore-separated names" do
      expect(described_class.capitalize("some_name")).to eq("SomeName")
    end

    it "capitalizes single words" do
      expect(described_class.capitalize("hello")).to eq("Hello")
    end

    it "accepts symbols via to_s" do
      expect(described_class.capitalize(:foo_bar)).to eq("FooBar")
    end

    # quirk: String#capitalize downcases the rest of each segment, so
    # already-camelized or uppercased input is squashed
    it "downcases the tail of each segment" do
      expect(described_class.capitalize("SomeName")).to eq("Somename")
      expect(described_class.capitalize("UPPER_case")).to eq("UpperCase")
    end

    it "returns an empty string for nil" do
      expect(described_class.capitalize(nil)).to eq("")
    end

    it "collapses consecutive underscores" do
      expect(described_class.capitalize("double__underscore")).to eq("DoubleUnderscore")
    end
  end

  describe ".paren_files" do
    it "returns the static list of paren classes" do
      files = described_class.paren_files
      expect(files).to be_an(Array)
      expect(files.length).to eq(24)
      expect(files).to all(be_a(Class))
    end

    it "contains only direct Paren subclasses" do
      files = described_class.paren_files
      expect(files).to include(
        Plurimath::Math::Symbols::Paren::Lround,
        Plurimath::Math::Symbols::Paren::Vert,
      )
      expect(files.all? { |klass| klass < Plurimath::Math::Symbols::Paren }).to be(true)
    end
  end

  describe ".symbols_files" do
    it "returns the static list of symbol classes" do
      files = described_class.symbols_files
      expect(files).to be_an(Array)
      expect(files.length).to eq(1436)
      expect(files).to all(be_a(Class))
    end

    it "includes named symbol classes" do
      expect(described_class.symbols_files).to include(
        Plurimath::Math::Symbols::Comma,
        Plurimath::Math::Symbols::Minus,
        Plurimath::Math::Symbols::Alpha,
      )
    end

    # quirk: descendants tracking only records DIRECT subclasses, so the list
    # includes the Paren base class itself but none of the paren leaf classes
    it "includes the Paren base class but not paren leaf classes" do
      files = described_class.symbols_files
      expect(files).to include(Plurimath::Math::Symbols::Paren)
      expect(files).not_to include(Plurimath::Math::Symbols::Paren::Lround)
    end
  end
end
