# 04 - mmultiscript containing none (MathML structure)

## Test Location
`spec/plurimath/mathml_spec.rb:1319`

## Issue Summary
Test "contains mmultiscript containing none tag" fails with MathML element_structure differences.

## Failure Details
- Element structure mismatch in MathML output
- The `<none>` tag handling may have changed

## Possible Cause
The LutaML-Model update changed how `<none>` elements inside `<mmultiscripts>` are handled.

## Status
**Pre-existing from LutaML-Model update**
