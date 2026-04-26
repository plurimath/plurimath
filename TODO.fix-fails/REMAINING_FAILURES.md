# MathML Translator: Remaining 14 Failing Tests

## Context

This document describes the 14 MathML translator tests that remain failing after the LutaML-Model update. The fixes for 17 other tests are in this PR; these require additional investigation.

---

## Summary of Fixed Tests

17 tests were resolved by addressing:
- `None#to_latex` and `None#to_asciimath` returning `nil` instead of `""`
- Whitespace preservation in `mo_to_symbol`
- Filtering empty strings from formula output
- Fixing `Plus#to_mathml_without_math_tag` to use `value` instead of hardcoded `"+"`

---

## Remaining 14 Failing Tests

### Category 1: MathML Structure Issues (5 tests)

#### 1. Test 281: Phantom Tag Whitespace
- **Location**: `spec/plurimath/mathml_spec.rb:281`
- **Test**: `contains Mathml phantom tag's example`
- **Issue**: Expected `<mo>+</mo>` (no spaces) inside `<mphantom>`, but output is `<mo> + </mo>` (with spaces)
- **Input**: `<mo> + </mo>` inside `<mphantom>`
- **Note**: The second `<mo> + </mo>` outside phantom correctly preserves spaces. Issue is specific to `mphantom`.

---

#### 2. Test 1197: Longidv Tag
- **Location**: `spec/plurimath/mathml_spec.rb:1197`
- **Test**: `contains longidv tag Mathml`
- **Issue**: 3 element_structure differences in XML comparison
- **Hint**: `longidv` involves `mscarries` elements. LutaML update changed parsing/rendering of these.

---

#### 3. Test 1319: Mmultiscript with None Tag
- **Location**: `spec/plurimath/mathml_spec.rb:1319`
- **Test**: `contains mmultiscript containing none tag`
- **Issue**: Element structure mismatch for `mmultiscripts` containing `<none>` elements

---

#### 4. Test 1366: Mstyle with Nary Oint
- **Location**: `spec/plurimath/mathml_spec.rb:1366`
- **Test**: `contains mstyle containing nary oint value in msubsup tag`
- **Issue**: Element structure differences with nary operators inside `msubsup`

---

#### 5. Test 1540: Issue #238
- **Location**: `spec/plurimath/mathml_spec.rb:1540`
- **Test**: `contains string from plurimath/issue#238`
- **Issue**: 4-5 element_structure differences in complex MathML structure

---

### Category 2: LaTeX Output Issues (3 tests)

#### 6. Test 778: Table with Parentheses (Metanorma)
- **Location**: `spec/plurimath/mathml_spec.rb:778`
- **Test**: `contains table with surrounding parentheses(metanorma example) and sqrt tag`
- **Issue**: LaTeX comparison fails - expected and got look identical but differ in invisible characters
- **Hint**: Use byte-level comparison (`xxd`, `od -c`) to identify the difference

---

#### 7. Test 1713: Metanorma BIPM Run
- **Location**: `spec/plurimath/mathml_spec.rb:1713`
- **Test**: `contains input from metanorma-cli-actions-mn-bipm run`
- **Expected**: `\underline{\mathit{B}} = \left [ ... \end{matrix}\right ]`
- **Got**: `\underset{ \left ( \underline \right ) }{ \left ( \mathit{B} \right ) } = \left [ ... \end{matrix}\right ]`
- **Hint**: `menclose` with `notation="updiagonalstrike"` rendering changed from `\underline{...}` to `\underset{...}{...}` form

---

#### 8. Test 1860: Metanorma ITU Run
- **Location**: `spec/plurimath/mathml_spec.rb:1860`
- **Test**: `contains input from metanorma-cli-actions-mn-itu run`
- **Expected**: `y_{k} = ( x_{k} \pm h )  m` (double space before `m`)
- **Got**: `y_{k} = ( x_{k} \pm h ) m` (single space)
- **Hint**: Related to how `None` elements contribute spacing

---

### Category 3: OMML Rendering Issues (6 tests)

**Root Cause**: Ox serializer outputs Unicode characters instead of HTML entities. See `TODO.bugs/05-omml-greek-entity-encoding.md`.

---

#### 9. Test 2452: Multiple Tags - Greek Encoding
- **Location**: `spec/plurimath/mathml_spec.rb:2452`
- **Expected**: `<m:t>&#x3b1;</m:t>`, `<m:t>&#x3b8;</m:t>`
- **Got**: `<m:t>α</m:t>`, `<m:t>θ</m:t>`

---

#### 10. Test 2663: Underover with Greek
- **Location**: `spec/plurimath/mathml_spec.rb:2663`
- **Expected**: `<m:t>&#x3b8;</m:t>`
- **Got**: `<m:t>θ</m:t>`

---

#### 11. Test 3121: Multiscripts None - ZWSP
- **Location**: `spec/plurimath/mathml_spec.rb:3121`
- **Expected**: `<m:t>&#8203;</m:t>` (ZWSP - Zero-Width Space)
- **Got**: `<m:t></m:t>` (empty)
- **Hint**: ZWSP (U+200B) used as placeholder in multiscripts is being dropped by Ox serializer

---

#### 12. Test 3201: Oint Msubsup - Missing Integral
- **Location**: `spec/plurimath/mathml_spec.rb:3201`
- **Expected**: Contains `<m:t>&#x222e;</m:t>` (contour integral ∮)
- **Got**: Integral symbol missing
- **Hint**: Nary operator `oint` not rendering in OMML within msubsup context

---

#### 13. Test 3365: Nary Prod Symbol
- **Location**: `spec/plurimath/mathml_spec.rb:3365`
- **Issue**: Same as test 12 - integral symbol `&#x222e;` missing
- **Hint**: Similar nary operator issue with product notation

---

#### 14. Test 3486: Empty MO Example
- **Location**: `spec/plurimath/mathml_spec.rb:3486`
- **Expected**: `<m:t>&#xb1;</m:t>` (plus-minus sign ±)
- **Got**: `<m:t></m:t>` (empty)
- **Hint**: Symbol value being lost in translation for empty `mo` elements

---

## Investigation Files

Detailed notes in:
- `TODO.fix-fails/01-phantom-whitespace.md` through `TODO.fix-fails/14-omml-empty-mo.md`
- `TODO.bugs/05-omml-greek-entity-encoding.md`

---

## Hints

1. **MathML Structure**: Compare AST structure before/after LutaML update. Focus on `translator.rb` handling of `mphantom`, `mmultiscripts`, `mscarries`, `munderover`.

2. **LaTeX Whitespace**: Use byte-level comparison to identify invisible character differences. Issue likely in how empty/nil values contribute spacing.

3. **OMML Issues**:
   - Greek encoding: Post-process Ox output to convert Unicode to HTML entities, or use Oga adapter instead
   - ZWSP/Empty MO: Investigate how Ox handles special Unicode characters (U+200B, U+00B1, U+222E)

---

## Testing

```bash
# All failing tests
bundle exec rspec spec/plurimath/mathml_spec.rb --format documentation

# Single test
bundle exec rspec spec/plurimath/mathml_spec.rb:281 --format documentation
```
