# 12 - OMML oint msubsup missing integral

## Test Location
`spec/plurimath/mathml_spec.rb:3201`

## Issue Summary
Test "contains oint msubsup tag" fails with OMML comparison.

## Expected
Structure includes `<m:t>&#x222e;</m:t>` (contour integral symbol ∮)

## Got
Missing the integral symbol in output

## Issue
The integral symbol `&#x222e;` is not appearing in the OMML output for nary operators.

## Status
**Pre-existing from LutaML-Model update**
