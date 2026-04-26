# Category 3: LaTeX Whitespace in Phantom

## Affected Tests
- 281: phantom tag's example

## Issue
Whitespace is stripped from phantom content in LaTeX output.

## Example Diff
```
Expected: " x  \\phantom{+} \\phantom{ y } +  z "
Actual:   "x \\phantom{+} \\phantom{y} + z"
```

Leading/trailing spaces inside `\phantom{}` are being lost.

## Root Cause
In `lib/plurimath/mathml/translator.rb`, `mi_to_symbol`:
```ruby
stripped = value.strip
...
result = Plurimath::Utility.mathml_unary_classes([stripped], lang: :mathml)
```

The whitespace is stripped when creating the Symbol. When Phantom renders via `latex_value`, it uses `parameter_one.to_latex` which returns the stripped value.

## Investigation Needed
1. Check if Symbol class should preserve whitespace in value
2. Or if Phantom class should handle whitespace differently

## Related Files
- `lib/plurimath/mathml/translator.rb:149-166` - mi_to_symbol
- `lib/plurimath/math/function/phantom.rb`
- `lib/plurimath/math/symbols/symbol.rb`
