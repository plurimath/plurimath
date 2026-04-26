# Category 4: MathML Structure Differences

## Affected Tests
- 213: contains Mathml object (msubsup in semantics)
- 778: table with surrounding parentheses
- 1197: longidv tag
- 1272: mpadded with attributes
- 1319: mmultiscript containing none tag
- 1366: mstyle containing nary oint value in msubsup
- 1540: plurimath/issue#238
- 1713: metanorma-cli-actions-mn-bipm

## Issue
Element structure differs - msubsup/mrow positions are wrong or elements are empty when they shouldn't be.

## Example Diff (test 213)
```
Position: mrow at position 0 vs position 1
Element differs: msubsup → (empty)
Element differs: mrow → (empty)
```

## Root Cause
Likely related to how mml parses `<semantics>` elements and orders children. The translator may not be properly handling the `semantics` wrapper and its `annotation` child elements.

## Investigation Needed
1. Check how mml gem parses semantics elements
2. Verify `mrow_to_mrow` correctly handles semantics content
3. Check `ordered_children` method for proper ordering

## Related Files
- `lib/plurimath/mathml/translator.rb` - mrow_to_mrow, ordered_children
- `lib/plurimath/math/formula.rb` - mrow handling
