# 14 - OMML empty mo example

## Test Location
`spec/plurimath/mathml_spec.rb:3486`

## Issue Summary
Test "contains empty mo example from plurimath/plurimath#318" fails with OMML comparison.

## Expected
`<m:t>&#xb1;</m:t>` (plus-minus sign ±)

## Got
`<m:t></m:t>` (empty)

## Issue
Empty `mo` element (representing ±) is not being rendered correctly in OMML output.

## Status
**Pre-existing from LutaML-Model update**
