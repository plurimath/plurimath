# 05 - mstyle containing nary oint (MathML structure)

## Test Location
`spec/plurimath/mathml_spec.rb:1366`

## Issue Summary
Test "contains mstyle containing nary oint value in msubsup tag" fails with MathML element_structure differences.

## Failure Details
- Element structure mismatch in MathML output
- Issue with nary operator rendering inside msubsup

## Possible Cause
The LutaML-Model update changed how nary operators are handled within subscript/superscript elements.

## Status
**Pre-existing from LutaML-Model update**
