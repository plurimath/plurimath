require "spec_helper"

# Characterization specs (refactor phase A0) for the UnicodeMath-side class
# methods on Plurimath::Utility, ahead of their move to
# Plurimath::UnicodeMath::Utility. These pin CURRENT behavior on main —
# including known bugs, each marked with a "# quirk:" comment — for a
# strictly behavior-preserving refactor. Do not "fix" an expectation here;
# behavior changes belong in a later, separate PR together with the
# production-code change.
#
# Input shapes mirror the real call sites in
# lib/plurimath/unicode_math/transform.rb (and, for unfenced_value,
# lib/plurimath/asciimath/transform.rb). The parser passes Parslet slices
# where these specs pass plain Strings; the methods only call
# to_s/to_sym/scan/decode on them, so behavior is identical (verified by
# instrumenting the live parser).
#
# NOTE: the suite-wide around hook runs every example twice (Ox then Oga),
# reusing the example instance. Several of these methods MUTATE their
# arguments, so all mutable inputs are built inside the example body (or via
# def helpers), never memoized with let.
RSpec.describe Plurimath::UnicodeMath::Utility do
  def symbol(value, *args, **kwargs)
    Plurimath::Math::Symbols::Symbol.new(value, *args, **kwargs)
  end

  def number(value, **kwargs)
    Plurimath::Math::Number.new(value, **kwargs)
  end

  def frac(numerator, denominator, options = {})
    Plurimath::Math::Function::Frac.new(numerator, denominator, options)
  end

  def base(param_one, param_two)
    Plurimath::Math::Function::Base.new(param_one, param_two)
  end

  def power(param_one, param_two)
    Plurimath::Math::Function::Power.new(param_one, param_two)
  end

  def overset(param_one, param_two)
    Plurimath::Math::Function::Overset.new(param_one, param_two, { accent: true })
  end

  def hat
    Plurimath::Math::Symbols::Hat.new
  end

  def round_fenced(values, options = {})
    Plurimath::Math::Function::Fenced.new(
      Plurimath::Math::Symbols::Paren::Lround.new,
      values,
      Plurimath::Math::Symbols::Paren::Rround.new,
      options,
    )
  end

  def square_fenced(values)
    Plurimath::Math::Function::Fenced.new(
      Plurimath::Math::Symbols::Paren::Lsquare.new,
      values,
      Plurimath::Math::Symbols::Paren::Rsquare.new,
    )
  end

  describe ".unicode_accents" do
    context "when accents is already a BinaryFunction (prime-power route)" do
      it "returns the object itself untouched" do
        accents = power(symbol("a"), Plurimath::Math::Symbols::Sprime.new)

        expect(described_class.unicode_accents(accents)).to be(accents)
      end
    end

    context "with a single base and a known accent entity (input like 'â')" do
      it "wraps the base in an accented Overset with the accent symbol class" do
        accents = [
          { first_value: symbol("a") },
          { accent_symbols: "&#x302;" },
        ]

        expect(described_class.unicode_accents(accents))
          .to eq(overset(hat, symbol("a")))
      end
    end

    context "with a named accent (ACCENT_SYMBOLS key such as 'hat')" do
      it "resolves the name through ACCENT_SYMBOLS to the symbol class" do
        accents = [
          { first_value: symbol("a") },
          { accent_symbols: "hat" },
        ]

        expect(described_class.unicode_accents(accents))
          .to eq(overset(hat, symbol("a")))
      end
    end

    # quirk: "&#x303;" (combining tilde) has no dedicated symbols_class
    # mapping on the :unicodemath path, so — unlike "&#x302;" → Hat — the
    # accent lands as a generic Symbol carrying the raw entity string.
    context "with the combining-tilde entity (input like 'ã')" do
      it "uses a generic Symbol holding the raw entity as the accent" do
        accents = [
          { first_value: symbol("a") },
          { accent_symbols: "&#x303;" },
        ]

        expect(described_class.unicode_accents(accents))
          .to eq(overset(symbol("&#x303;"), symbol("a")))
      end
    end

    context "when first_value is an Array (input like 'ab̂')" do
      # quirk: this branch mutates the input — it pops the last element out
      # of accents.first[:first_value] and reassigns the hash entry.
      it "accents only the last element and keeps the rest alongside it" do
        accents = [
          { first_value: [symbol("a"), symbol("b")] },
          { accent_symbols: "&#x302;" },
        ]

        expect(described_class.unicode_accents(accents)).to eq(
          Plurimath::Math::Formula.new(
            [symbol("a"), overset(hat, symbol("b"))],
          ),
        )
      end
    end

    context "with two stacked accents (input like 'ẫ')" do
      it "nests Oversets left to right" do
        accents = [
          { first_value: symbol("a") },
          { accent_symbols: "&#x302;" },
          { accent_symbols: "&#x303;" },
        ]

        expect(described_class.unicode_accents(accents)).to eq(
          overset(symbol("&#x303;"), overset(hat, symbol("a"))),
        )
      end
    end

    # quirk: a trailing prime accent becomes a Power whose exponent is the
    # RAW entity String ("&#x2032;"), not a Math object — filter_values
    # passes non-Array/non-Formula input straight through.
    context "with an accent followed by a prime (input like 'â′')" do
      it "returns a Power with the raw prime entity string as exponent" do
        accents = [
          { first_value: symbol("a") },
          { accent_symbols: "&#x302;" },
          { prime_accent_symbols: "&#x2032;" },
        ]

        expect(described_class.unicode_accents(accents)).to eq(
          power(overset(hat, symbol("a")), "&#x2032;"),
        )
      end
    end

    # quirk: when the prime hash immediately follows the base hash, the
    # prime is treated as an ACCENT (Overset) whose accent slot holds the
    # raw entity String — not as a Power exponent.
    context "with a prime hash directly after the base hash" do
      it "builds an Overset with the raw prime entity string on top" do
        accents = [
          { first_value: symbol("a") },
          { prime_accent_symbols: "&#x2032;" },
        ]

        expect(described_class.unicode_accents(accents)).to eq(
          Plurimath::Math::Function::Overset.new(
            "&#x2032;", symbol("a"), { accent: true }
          ),
        )
      end
    end

    # quirk: with a prime hash in FIRST position the prime string becomes
    # the Power BASE and the following accent becomes the exponent.
    context "with a prime hash in first position" do
      it "returns Power(raw prime string, accent symbol)" do
        accents = [
          { prime_accent_symbols: "&#x2032;" },
          { accent_symbols: "&#x302;" },
        ]

        expect(described_class.unicode_accents(accents))
          .to eq(power("&#x2032;", hat))
      end
    end

    context "when first_value is a plain round Fenced (input like '(a)̂')" do
      it "unwraps the parens before accenting" do
        accents = [
          { first_value: round_fenced([symbol("a")]) },
          { accent_symbols: "&#x302;" },
        ]

        expect(described_class.unicode_accents(accents))
          .to eq(overset(hat, symbol("a")))
      end
    end
  end

  describe ".unicode_fractions" do
    context "with a vulgar-fraction entity from UNICODE_FRACTIONS ('½')" do
      it "returns a non-displaystyle Frac tagged as a unicodemath fraction" do
        expect(described_class.unicode_fractions("&#xbd;")).to eq(
          frac(
            number("1"),
            number("2"),
            { displaystyle: false, unicodemath_fraction: true },
          ),
        )
      end
    end

    # quirk: an entity missing from UNICODE_FRACTIONS crashes with
    # NoMethodError (nil.first) instead of failing gracefully. The parser
    # only feeds known fraction characters, so this is latent.
    context "with an entity not present in UNICODE_FRACTIONS" do
      it "raises NoMethodError on the nil lookup" do
        expect { described_class.unicode_fractions("&#x9999;") }
          .to raise_error(NoMethodError)
      end
    end
  end

  describe ".updated_primes" do
    context "with a single ASCII-apostrophe entity (input like \"a'\")" do
      it "returns a lone Sprime symbol" do
        expect(described_class.updated_primes("&#x27;"))
          .to eq(Plurimath::Math::Symbols::Sprime.new)
      end
    end

    context "with repeated apostrophe entities (input like \"a'''\")" do
      it "returns a Formula of one Sprime per entity" do
        expect(described_class.updated_primes("&#x27;&#x27;&#x27;")).to eq(
          Plurimath::Math::Formula.new(
            [
              Plurimath::Math::Symbols::Sprime.new,
              Plurimath::Math::Symbols::Sprime.new,
              Plurimath::Math::Symbols::Sprime.new,
            ],
          ),
        )
      end
    end

    context "with mixed prime entities (input like 'a′″')" do
      it "maps each entity to its own symbol class" do
        expect(described_class.updated_primes("&#x2032;&#x2033;")).to eq(
          Plurimath::Math::Formula.new(
            [
              Plurimath::Math::Symbols::Prime.new,
              Plurimath::Math::Symbols::Dprime.new,
            ],
          ),
        )
      end
    end

    # quirk: only "&#x...;" entities are scanned — a raw apostrophe (or any
    # non-entity text) yields no matches and the method returns nil.
    context "with a raw (non-entity) apostrophe" do
      it "returns nil" do
        expect(described_class.updated_primes("'")).to be_nil
      end
    end

    context "with nil" do
      it "returns nil" do
        expect(described_class.updated_primes(nil)).to be_nil
      end
    end
  end

  describe ".fractions" do
    context "with plain numerator and denominator and no options" do
      it "returns a Frac without options" do
        expect(described_class.fractions(symbol("a"), symbol("b")))
          .to eq(frac(symbol("a"), symbol("b")))
      end
    end

    context "with options" do
      it "passes the options through to the Frac" do
        result = described_class.fractions(
          symbol("a"), symbol("b"), { displaystyle: false }
        )

        expect(result).to eq(
          frac(symbol("a"), symbol("b"), { displaystyle: false }),
        )
      end
    end

    context "when the denominator is already a Frac (input like 'a/b/c')" do
      it "mutates the denominator, nesting the new Frac as its numerator" do
        denominator = frac(symbol("b"), symbol("c"))

        result = described_class.fractions(symbol("a"), denominator)

        expect(result).to be(denominator)
        expect(result).to eq(
          frac(frac(symbol("a"), symbol("b")), symbol("c")),
        )
      end
    end

    context "when the denominator nests Fracs (input like 'a/b/c/d')" do
      it "recurses to the deepest numerator" do
        denominator = frac(frac(symbol("b"), symbol("c")), symbol("d"))

        result = described_class.fractions(symbol("a"), denominator, nil)

        expect(result).to be(denominator)
        expect(result).to eq(
          frac(frac(frac(symbol("a"), symbol("b")), symbol("c")), symbol("d")),
        )
      end
    end

    context "with round-fenced operands (input like '(x)/(y)')" do
      it "unwraps plain round parens on both sides" do
        result = described_class.fractions(
          round_fenced([symbol("x")]),
          round_fenced([symbol("y")]),
        )

        expect(result).to eq(frac(symbol("x"), symbol("y")))
      end
    end
  end

  describe ".recursive_sub" do
    context "when the recursion value is not a Base (input like 'x_a_b')" do
      it "returns a new Base of the two values" do
        expect(described_class.recursive_sub(symbol("a"), symbol("b")))
          .to eq(base(symbol("a"), symbol("b")))
      end
    end

    context "when the recursion value is a Base (input like 'x_a_b_c')" do
      it "mutates it, nesting the script as the inner base" do
        recursion = base(symbol("b"), symbol("c"))

        result = described_class.recursive_sub(symbol("a"), recursion)

        expect(result).to be(recursion)
        expect(result).to eq(base(base(symbol("a"), symbol("b")), symbol("c")))
      end
    end

    context "when the recursion value nests Bases (input like 'x_a_b_c_d')" do
      it "recurses to the deepest parameter_one" do
        recursion = base(base(symbol("b"), symbol("c")), symbol("d"))

        result = described_class.recursive_sub(symbol("a"), recursion)

        expect(result).to be(recursion)
        expect(result).to eq(
          base(base(base(symbol("a"), symbol("b")), symbol("c")), symbol("d")),
        )
      end
    end
  end

  describe ".recursive_sup" do
    context "when the recursion value is not a Power (input like 'y^a^b')" do
      it "returns a new Power of the two values" do
        expect(described_class.recursive_sup(symbol("a"), symbol("b")))
          .to eq(power(symbol("a"), symbol("b")))
      end
    end

    context "when the recursion value is a Power (input like 'y^a^b^c')" do
      it "mutates it, nesting the script as the inner base" do
        recursion = power(symbol("b"), symbol("c"))

        result = described_class.recursive_sup(symbol("a"), recursion)

        expect(result).to be(recursion)
        expect(result).to eq(
          power(power(symbol("a"), symbol("b")), symbol("c")),
        )
      end
    end

    context "when the recursion value nests Powers (input like 'y^a^b^c^d')" do
      it "recurses to the deepest parameter_one" do
        recursion = power(power(symbol("b"), symbol("c")), symbol("d"))

        result = described_class.recursive_sup(symbol("a"), recursion)

        expect(result).to be(recursion)
        expect(result).to eq(
          power(
            power(power(symbol("a"), symbol("b")), symbol("c")),
            symbol("d"),
          ),
        )
      end
    end
  end

  describe ".base_is_prime?" do
    # quirk: despite the ? name, truthy results are the Hash#key lookup —
    # a Symbol like :sprime or :prime — not true.
    context "when the exponent is a prime symbol class (input like \"a'_b\")" do
      it "returns the prime key :sprime for an Sprime exponent" do
        prime_base = power(symbol("a"), Plurimath::Math::Symbols::Sprime.new)

        expect(described_class.base_is_prime?(prime_base)).to eq(:sprime)
      end

      it "returns the prime key :prime for a Prime exponent" do
        prime_base = power(symbol("a"), Plurimath::Math::Symbols::Prime.new)

        expect(described_class.base_is_prime?(prime_base)).to eq(:prime)
      end
    end

    context "when the exponent is a generic Symbol holding a prime entity" do
      it "falls back to the value lookup and returns the prime key" do
        prime_base = power(symbol("a"), symbol("&#x2032;"))

        expect(described_class.base_is_prime?(prime_base)).to eq(:prime)
      end
    end

    context "when the exponent is not a prime" do
      it "returns nil for a Number exponent" do
        expect(described_class.base_is_prime?(power(symbol("a"), number("2"))))
          .to be_nil
      end

      it "returns nil for a non-prime Symbol exponent" do
        expect(described_class.base_is_prime?(power(symbol("a"), symbol("b"))))
          .to be_nil
      end

      it "returns nil for a Formula exponent (multiple primes)" do
        exponent = Plurimath::Math::Formula.new(
          [
            Plurimath::Math::Symbols::Prime.new,
            Plurimath::Math::Symbols::Dprime.new,
          ],
        )

        expect(described_class.base_is_prime?(power(symbol("a"), exponent)))
          .to be_nil
      end
    end
  end

  describe ".base_is_sub_or_sup?" do
    context "with a mini-sub-sized Number (input like 'a₂')" do
      it "returns true" do
        expect(
          described_class.base_is_sub_or_sup?(
            number("2", mini_sub_sized: true),
          ),
        ).to be(true)
      end
    end

    context "with a mini-sub-sized Symbol" do
      it "returns true" do
        expect(
          described_class.base_is_sub_or_sup?(
            symbol("a", mini_sub_sized: true),
          ),
        ).to be(true)
      end
    end

    context "with a Formula wrapping a mini-sub-sized value" do
      it "recurses into the first value and returns true" do
        formula = Plurimath::Math::Formula.new(
          [number("1", mini_sub_sized: true)],
        )

        expect(described_class.base_is_sub_or_sup?(formula)).to be(true)
      end
    end

    context "with a Fenced wrapping a mini-sub-sized value" do
      it "recurses into the first fenced value and returns true" do
        fenced = round_fenced([number("1", mini_sub_sized: true)])

        expect(described_class.base_is_sub_or_sup?(fenced)).to be(true)
      end
    end

    # quirk: the second operand of the || is the typo `base_mini_sup_sized`
    # (instead of `base.mini_sup_sized`), which is undefined on Utility. Any
    # Symbol/Number whose mini_sub_sized is falsy therefore raises NameError
    # — including mini_SUP_sized values, which can never return true.
    context "with a Symbol that is not mini-sub-sized" do
      it "raises NameError from the base_mini_sup_sized typo" do
        expect { described_class.base_is_sub_or_sup?(symbol("a")) }
          .to raise_error(NameError, /base_mini_sup_sized/)
      end

      it "raises NameError even when the symbol is mini-sup-sized" do
        expect do
          described_class.base_is_sub_or_sup?(
            symbol("a", mini_sup_sized: true),
          )
        end.to raise_error(NameError, /base_mini_sup_sized/)
      end
    end

    context "with a node outside the case branches" do
      it "returns nil for a Text function" do
        text = Plurimath::Math::Function::Text.new("x")

        expect(described_class.base_is_sub_or_sup?(text)).to be_nil
      end

      it "returns nil for an empty Formula" do
        formula = Plurimath::Math::Formula.new([])

        expect(described_class.base_is_sub_or_sup?(formula)).to be_nil
      end
    end
  end

  describe ".identity_matrix" do
    def td_number(digit)
      Plurimath::Math::Function::Td.new([number(digit)])
    end

    context "with size 2 (input like '■2' after to_i)" do
      it "returns Tr rows of Td-wrapped 1/0 numbers with 1s on the diagonal" do
        expect(described_class.identity_matrix(2)).to eq(
          [
            Plurimath::Math::Function::Tr.new([td_number("1"), td_number("0")]),
            Plurimath::Math::Function::Tr.new([td_number("0"), td_number("1")]),
          ],
        )
      end
    end

    context "with size 1" do
      it "returns a single row holding a single 1" do
        expect(described_class.identity_matrix(1)).to eq(
          [Plurimath::Math::Function::Tr.new([td_number("1")])],
        )
      end
    end

    context "with size 0" do
      it "returns an empty array" do
        expect(described_class.identity_matrix(0)).to eq([])
      end
    end
  end

  describe ".enclosure_attrs" do
    # The mask's low nibble is XORed with 15, so 0 enables all four sides
    # and 15 disables them; bits 16..128 map to the strike classes directly.
    it "returns all four sides for mask 0" do
      expect(described_class.enclosure_attrs(0)).to eq("top bottom left right")
    end

    it "returns 'bottom left right' for mask 1 (top removed)" do
      expect(described_class.enclosure_attrs(1)).to eq("bottom left right")
    end

    it "returns 'bottom right' for mask 5" do
      expect(described_class.enclosure_attrs(5)).to eq("bottom right")
    end

    it "returns an empty string for mask 15" do
      expect(described_class.enclosure_attrs(15)).to eq("")
    end

    it "returns 'downdiagonalstrike' for mask 79" do
      expect(described_class.enclosure_attrs(79)).to eq("downdiagonalstrike")
    end

    it "returns all strike classes for mask 255" do
      expect(described_class.enclosure_attrs(255)).to eq(
        "horizontalstrike verticalstrike downdiagonalstrike updiagonalstrike",
      )
    end

    context "with an out-of-range or missing mask" do
      it "raises for nil" do
        expect { described_class.enclosure_attrs(nil) }
          .to raise_error(RuntimeError, "enclosure mask is not between 0 and 255")
      end

      it "raises for a negative mask" do
        expect { described_class.enclosure_attrs(-1) }
          .to raise_error(RuntimeError, "enclosure mask is not between 0 and 255")
      end

      it "raises for a mask above 255" do
        expect { described_class.enclosure_attrs(256) }
          .to raise_error(RuntimeError, "enclosure mask is not between 0 and 255")
      end
    end
  end

  describe ".slashed_values" do
    context "when the decoded value starts with a word character" do
      it "returns a Text with a backslash prefix for digits" do
        expect(described_class.slashed_values("12"))
          .to eq(Plurimath::Math::Function::Text.new("\\12"))
      end

      it "returns a Text with a backslash prefix for letters" do
        expect(described_class.slashed_values("alpha"))
          .to eq(Plurimath::Math::Function::Text.new("\\alpha"))
      end
    end

    context "when the decoded value is not a word character" do
      it "returns a slashed Symbol with the decoded character" do
        expect(described_class.slashed_values("&#x226e;"))
          .to eq(symbol("≮", true))
      end

      it "returns a slashed Symbol for a bare backslash" do
        expect(described_class.slashed_values("\\")).to eq(symbol("\\", true))
      end
    end
  end

  describe ".sequence_slashed_values" do
    context "with a leading number node (input like '\\12ab')" do
      it "slashes the first value and re-resolves the rest, mutating in place" do
        values = [number("12"), symbol("ab")]

        result = described_class.sequence_slashed_values(
          values, lang: :unicodemath
        )

        expect(result).to be(values)
        expect(result).to eq(
          [Plurimath::Math::Function::Text.new("\\12"), symbol("ab")],
        )
      end
    end

    context "with digits after the first value" do
      it "turns later digit values into Numbers" do
        result = described_class.sequence_slashed_values(
          [symbol("ab"), number("12")], lang: :unicodemath
        )

        expect(result).to eq(
          [Plurimath::Math::Function::Text.new("\\ab"), number("12")],
        )
      end
    end

    context "with an entity after the first value" do
      it "decodes it and resolves it through symbols_class" do
        result = described_class.sequence_slashed_values(
          [symbol("ab"), symbol("&#x2264;")], lang: :unicodemath
        )

        expect(result).to eq(
          [Plurimath::Math::Function::Text.new("\\ab"), symbol("≤")],
        )
      end
    end

    context "with an empty array" do
      it "returns the empty array" do
        expect(described_class.sequence_slashed_values([], lang: :unicodemath))
          .to eq([])
      end
    end
  end

  describe ".unfenced_value" do
    context "with a plain round Fenced and paren_specific: true" do
      it "unwraps a single-value Fenced to the value itself" do
        fenced = round_fenced([symbol("x")])

        expect(described_class.unfenced_value(fenced, paren_specific: true))
          .to eq(symbol("x"))
      end

      it "unwraps a multi-value Fenced to a Formula" do
        fenced = round_fenced([symbol("x"), symbol("y")])

        expect(described_class.unfenced_value(fenced, paren_specific: true))
          .to eq(Plurimath::Math::Formula.new([symbol("x"), symbol("y")]))
      end
    end

    context "with a non-round Fenced" do
      it "keeps the Fenced untouched when paren_specific: true" do
        fenced = square_fenced([symbol("x")])

        expect(described_class.unfenced_value(fenced, paren_specific: true))
          .to be(fenced)
      end

      it "still unwraps it when paren_specific is false (default)" do
        fenced = square_fenced([symbol("x")])

        expect(described_class.unfenced_value(fenced)).to eq(symbol("x"))
      end
    end

    context "with a round Fenced carrying paren options" do
      it "keeps the Fenced untouched when paren_specific: true" do
        fenced = round_fenced([symbol("x")], { open_paren: "(" })

        expect(described_class.unfenced_value(fenced, paren_specific: true))
          .to be(fenced)
      end
    end

    context "with an Array" do
      it "wraps multiple values in a Formula" do
        expect(described_class.unfenced_value([symbol("x"), symbol("y")]))
          .to eq(Plurimath::Math::Formula.new([symbol("x"), symbol("y")]))
      end

      it "unwraps a single-element array to the element" do
        expect(described_class.unfenced_value([symbol("x")]))
          .to eq(symbol("x"))
      end

      # quirk: an empty array filters down to nil, not an empty Formula.
      it "returns nil for an empty array" do
        expect(described_class.unfenced_value([])).to be_nil
      end
    end

    context "with any other object" do
      it "returns the object itself" do
        value = symbol("x")

        expect(described_class.unfenced_value(value)).to be(value)
      end

      it "returns nil for nil" do
        expect(described_class.unfenced_value(nil)).to be_nil
      end
    end
  end
end
