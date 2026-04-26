# 10 - OMML Greek letter encoding (underover)

## Test Location
`spec/plurimath/mathml_spec.rb:2663`

## Issue Summary
Test "contains underover, under, and over tags with displaystyle false" fails with OMML comparison.

## Expected
`<m:t>&#x3b8;</m:t>` (HTML entity)

## Got
`<m:t>θ</m:t>` (Unicode character)

## Issue
Greek letter theta encoding issue - same as test 09.

## Status
**Pre-existing from LutaML-Model update - KNOWN ISSUE**
