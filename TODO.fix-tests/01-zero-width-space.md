# Category 1: ZERO WIDTH SPACE Serialization in OMML

## Affected Tests
- 2452: contains multiple tags in Mathml
- 2913: mfrac with options/attributes tag
- 3039: mpadded with attributes
- 3121: multiscripts containing none tag
- 3201: oint msubsup tag
- 3365: nary prod symbol in underover
- 3486: empty mo example from plurimath/plurimath#318

## Issue
`<m:t>&#8203;</m:t>` (zero-width space) becomes `<m:t></m:t>` or `<m:t/>` in OMML output.

## Root Cause
In `lib/plurimath/math/core.rb`, the `empty_tag` method:
```ruby
def empty_tag(wrapper_tag = nil)
  r_tag = ox_element("r", namespace: "m")
  r_tag << (ox_element("t", namespace: "m") << "&#8203;")
  ...
end
```

The `&#8203;` entity is being lost during Ox element serialization.

## Investigation Needed
1. Check how `ox_element` and Ox handle HTML entities in text content
2. Verify if this is a lutaml-model issue or an issue with how Plurimath uses Ox
3. Test if using raw Unicode character U+200B directly works instead of entity

## Related Files
- `lib/plurimath/math/core.rb:48-54` - empty_tag method
- `lib/plurimath/math/symbols/symbol.rb` - Symbol rendering
