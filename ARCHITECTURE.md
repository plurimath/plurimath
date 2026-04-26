# Architectural Change: Plurimath Formula as Universal Math Model

## Summary

This PR establishes the **Plurimath Formula model** as the universal mathematical model for Plurimath, replacing MathML as the central interchange format. All math representation languages (MathML, LaTeX, OMML, UnicodeMath, AsciiMath) now convert TO the Formula model, then render TO any other representation.

---

## Before This PR

MathML (mml gem models) served as the de facto universal model. Parsing converted input to MathML models, and rendering converted from MathML models to output formats.

```
Input → MathML Models → Output
         (as universal model)
```

---

## After This PR

Plurimath Formula model is the universal model. The Translator converts MathML models to Formula, and Formula renders to all output formats.

```
MathML Models → Translator → Plurimath Formula model → Renderer → LaTeX
                                     ↓
                                     → Renderer → OMML
                                     ↓
                                     → Renderer → UnicodeMath
                                     ↓
                                     → Renderer → AsciiMath
```

---

## Core Components

### Plurimath Formula model (`lib/plurimath/math/formula.rb`)

The `Formula` class is the central data structure - a recursive tree that represents mathematical structure:

- `Formula` contains an array of `value` items
- Each item can be: `Number`, `Symbol`, `BinaryFunction`, `UnaryFunction`, `NaryFunction`, `Formula::Mrow`, etc.
- Functions wrap other formulas or values to represent operators, fences, scripts, etc.

### Translator (`lib/plurimath/mathml/translator.rb`)

The `Translator` class bridges **MathML models** and the **Plurimath Formula model**:

- Takes `Mml::V4::*` model nodes as input
- Converts them to corresponding `Plurimath::Math::*` classes (Formula nodes)
- Handles element-specific translation logic (e.g., `mo_to_symbol`, `mphantom_to_phantom`)

### Renderer

Each Formula node knows how to render itself to different formats:

- `to_latex` - LaTeX output
- `to_mathml` - MathML output
- `to_omml` - Office Math (OMML) output
- `to_unicodemath` - UnicodeMath output
- `to_asciimath` - AsciiMath output

---

## LutaML-Model 0.8.0 Update Impact

The upgrade to `lutaml-model 0.8.0` changed the mml gem models, which affected:

1. **Attribute access** - Model attributes changed or moved
2. **Element handling** - Some elements now behave differently
3. **Serialization** - Ox vs Oga adapters produce different output

This PR fixes 17 MathML translator tests that broke due to these changes, with 14 remaining that require further investigation.

---

## Key Files Changed

| File | Purpose |
|------|---------|
| `lib/plurimath/math/formula.rb` | Plurimath Formula model definition and rendering |
| `lib/plurimath/math/core.rb` | Base class for math elements |
| `lib/plurimath/math/symbols/symbol.rb` | Symbol element handling |
| `lib/plurimath/math/number.rb` | Number element |
| `lib/plurimath/mathml/translator.rb` | MathML → Plurimath Formula translation |
| `lib/plurimath/utility.rb` | Utility functions |

---

## Benefits of Plurimath Formula as Universal Model

1. **Consistency** - All representations go through the same Plurimath Formula model
2. **Extensibility** - Easy to add new representation languages
3. **Separation of concerns** - Parsing (to Formula) and rendering (from Formula) are separate
4. **Testability** - Plurimath Formula is a plain Ruby object, easy to construct and inspect

---

## Remaining Work

14 tests in `spec/plurimath/mathml_spec.rb` still fail due to the LutaML update. See `TODO.fix-fails/REMAINING_FAILURES.md` for details.
