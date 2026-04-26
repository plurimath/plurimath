# 02 - table with parentheses (LaTeX trailing space)

## Test Location
`spec/plurimath/mathml_spec.rb:778`

## Issue Summary
Test "contains table with surrounding parentheses(metanorma example) and sqrt tag" fails on LaTeX comparison.

## Failure Details
- Expected and got appear identical but differ in invisible characters or whitespace
- The test uses `to_latex` comparison

## Possible Cause
The LaTeX output has extra whitespace/trailing spaces that don't match the expected.

## Status
**Pre-existing from LutaML-Model update**
