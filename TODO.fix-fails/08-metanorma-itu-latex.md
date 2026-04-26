# 08 - metanorma-cli-actions-mn-itu (LaTeX spacing)

## Test Location
`spec/plurimath/mathml_spec.rb:1860`

## Issue Summary
Test "contains input from metanorma-cli-actions-mn-itu run" fails with LaTeX comparison.

## Expected
`y_{k} = ( x_{k} \pm h )  m`
(Got: `y_{k} = ( x_{k} \pm h ) m`)

## Issue
Double space before `m` in expected, single space in our output. This is likely related to how `None#to_latex` or similar empty-returning functions are handled.

## Status
**Pre-existing from LutaML-Model update**
