# 01 - phantom tag whitespace issue

## Test Location
`spec/plurimath/mathml_spec.rb:281`

## Issue Summary
Test "contains Mathml phantom tag's example" fails with XML equivalence check.

## Input MathML
```xml
<math>
   <mrow>
      <mi> x </mi>
      <mphantom>
         <mo> + </mo>
      </mphantom>
      <mphantom>
         <mi> y </mi>
      </mphantom>
      <mo> + </mo>
      <mi> z </mi>
   </mrow>
</math>
```

## Expected MathML (from test)
```xml
<mphantom>
  <mo>+</mo>
</mphantom>
<mphantom>
  <mi> y </mi>
</mphantom>
<mo> + </mo>
```

## Our Output
```xml
<mphantom>
  <mo> + </mo>
</mphantom>
<mphantom>
  <mi> y </mi>
</mphantom>
<mo> + </mo>
```

## Difference
- Expected first mo inside phantom: `<mo>+</mo>` (no spaces)
- Our output first mo inside phantom: `<mo> + </mo>` (with spaces)

The second mo (outside phantom) correctly preserves spaces.

## Analysis
The issue is that `mphantom` is not supposed to preserve the whitespace inside the `mo` element according to the expected test output. However, this seems semantically incorrect - if the input has `<mo> + </mo>`, the spaces are part of the mo content.

## Status
**Pre-existing from LutaML-Model update** - This test was passing before the update, meaning the previous code stripped spaces inside mo elements when inside phantom.

## Possible Causes
1. The LutaML-Model update changed how `mo_to_symbol` preserves whitespace
2. The test expectation was always semantically questionable but matched the previous implementation
3. Something in the translator is now preserving whitespace that was previously stripped
