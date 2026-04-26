# 11 - OMML multiscripts ZWSP handling

## Test Location
`spec/plurimath/mathml_spec.rb:3121`

## Issue Summary
Test "contains multiscripts containing none tag" fails with OMML comparison.

## Expected
`<m:t>&#8203;</m:t>` (ZWSP - Zero-Width Space)

## Got
`<m:t></m:t>` (empty)

## Issue
ZWSP (Zero-Width Space, U+200B) placeholder is not being rendered in OMML output. The empty `m:t` element suggests the ZWSP character is being lost.

## Status
**Pre-existing from LutaML-Model update**
