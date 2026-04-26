# Category 2: HTML Linebreak Positioning

## Affected Tests
- 3594: contains subsup and linebreak with different values example in MathML

## Issue
`<br/>` is positioned BEFORE the operator instead of AFTER when `linebreakstyle="after"` is set.

## Example Diff
```
Expected: "<i>N</i><sub>s</sub><sup>2</sup> =<br/> T <br/>&#x2191; S <br/> D"
Actual:   "<i>N</i><sub>s</sub><sup>2</sup> <br/>= T <br/>↑ S <br/> D"
```

Note: Also `&#x2191;` (entity) becomes `↑` (literal Unicode character).

## Root Cause
In `lib/plurimath/math/function/linebreak.rb`, the `to_html` method:
```ruby
def to_html(options:)
  br_tag = "<br/>"
  return br_tag unless parameter_one

  case attributes[:linebreakstyle]
  when "after"
    "#{parameter_one.to_html(options: options)}#{br_tag}"
  else
    "#{br_tag}#{parameter_one.to_html(options: options)}"
  end
end
```

The `linebreakstyle` attribute is being passed from MathML but may not be properly captured or applied.

## Investigation Needed
1. Check if `mo_to_symbol` properly captures `linebreakstyle` attribute from `<mo linebreak="newline" linebreakstyle="after">`
2. Verify that Linebreak class stores and uses this attribute correctly

## Related Files
- `lib/plurimath/math/function/linebreak.rb`
- `lib/plurimath/mathml/translator.rb` - mo_to_symbol
