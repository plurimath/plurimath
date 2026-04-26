# Bad Symbol.new Usages in translator.rb

## Line 577 (FIXED)
```ruby
Plurimath::Math::Symbols::Symbol.new("(", mo_element: true)
```
Was used in `combine_function_with_parens` to create opening parenthesis.
FIXED: Now uses `next_elem` directly if it's a Paren object, or creates `Paren::Lround.new` as fallback.
Problem with old code: It was ignoring the existing `Paren::Lround` object returned by `mo_to_symbol` and creating a generic Symbol.

## Line 171 - mo_element= (FIXED)
```ruby
result.mo_element = true
```
This was setting mo_element on Symbol objects returned by mathml_unary_classes.
FIXED: Removed this line as Symbol class doesn't have mo_element attribute and doesn't need it.
The Paren classes already know how to render themselves as `<mo>` via their own to_mathml_without_math_tag method.

## Line 169-175 - linebreakstyle not passed (FIXED)
```ruby
return Plurimath::Math::Function::Linebreak.new(
  Plurimath::Math::Symbols::Symbol.new(value)
)
```
The `linebreakstyle` attribute was not being passed to Linebreak constructor.
FIXED: Now passes `linebreakstyle` attribute and uses `mathml_unary_classes` for proper encoding.

## Line 159 - whitespace stripped (PARTIALLY FIXED)
```ruby
result = Plurimath::Utility.mathml_unary_classes([stripped], lang: :mathml)
```
Whitespace was being stripped from Symbol values, causing phantom content to lose spaces.
FIXED for LaTeX output: Restores original value after `mathml_unary_classes` creates the Symbol.
MathML structure issue remains a pre-existing bug.

## Remaining Issues - SEE TODO.fix-tests/

Detailed investigation reports for the remaining 19 test failures are in `TODO.fix-tests/`:

- 00-overview.md - Summary of all failures
- 01-zero-width-space.md - OMML empty element serialization
- 02-html-linebreak.md - HTML linebreak positioning (FIXED)
- 03-phantom-whitespace.md - LaTeX whitespace in phantom (PARTIALLY FIXED)
- 04-mathml-structure.md - MathML structure differences
- 05-omml-rendering.md - OMML rendering issues
