# 09 - OMML Greek letter encoding (multiple tags)

## Test Location
`spec/plurimath/mathml_spec.rb:2452`

## Issue Summary
Test "contains multiple tags in Mathml" fails with OMML comparison due to Greek letter encoding.

## Expected
`<m:t>&#x3b1;</m:t>` (HTML entity)
`<m:t>&#x3b8;</m:t>` (HTML entity)

## Got
`<m:t>α</m:t>` (Unicode character)
`<m:t>θ</m:t>` (Unicode character)

## Issue
Greek letters are being output as Unicode characters instead of HTML entities. This is the **Greek letter encoding issue** documented in `TODO.bugs/05-omml-greek-entity-encoding.md`.

## Cause
Ox serializer outputs Unicode characters directly instead of HTML entities.

## Status
**Pre-existing from LutaML-Model update - KNOWN ISSUE**
