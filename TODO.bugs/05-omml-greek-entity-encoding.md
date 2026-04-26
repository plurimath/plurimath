# Greek Letter HTML Entity Serialization in moxml Ox Adapter

## Issue

When using the `moxml` gem with the Ox adapter, Greek letters (and other special Unicode characters) are serialized as raw Unicode characters instead of HTML entities.

**Example:**
- Expected: `<m:t>&#x3b8;</m:t>` (theta as HTML entity)
- Actual: `<m:t>θ</m:t>` (theta as raw Unicode character)

## Affected Tests

All OMML comparison tests in plurimath:

| Test # | Name | Issue |
|--------|------|-------|
| 2452 | contains multiple tags in Mathml | Greek letters (α, θ) as Unicode vs HTML entities |
| 2663 | contains underover, under, and over tags | Greek letter θ encoding |
| 3121 | multiscripts containing none tag | ZWSP (&#8203;) not rendered - empty m:t |
| 3201 | oint msubsup tag | Integral symbol (&#x222e;) missing in output |
| 3365 | nary prod symbol in underover | Integral symbol (&#x222e;) missing |
| 3486 | empty mo example from plurimath#318 | Empty mo (&#xb1; ±) not rendered |

## Root Cause

The moxml gem's Ox adapter uses `Ox.dump()` to serialize XML. Ox serializes text content as raw Unicode characters rather than HTML entities.

When a symbol like `θ` (theta, U+03B8) is stored as a text node, Ox outputs it as `θ` instead of `&#x3b8;`.

## Expected Behavior

For MathML/OMML output, certain characters should be serialized as HTML entities:
- Greek letters: `&#x3b8;` for `θ`, `&#x3b1;` for `α`, `&#x3b2;` for `β`
- Zero-width space: `&#8203;` for ZWSP
- Operators: `&#xb1;` for `±`, `&#x222e;` for `∮`

## Solution

The Ox adapter's serialize method needs to post-process text content to encode certain Unicode characters as HTML entities. This could be done in:

1. `moxml/lib/moxml/adapter/ox.rb` - modify the `serialize` method to post-process text nodes
2. Or create a text encoding step when adding text content to elements

## Alternative

Use the Oga adapter instead of Ox adapter. The Oga adapter appears to handle HTML entity encoding correctly (based on test outputs showing `&#8203;` preserved with Oga).

## Context

This is a serialization issue in the moxml library, not in plurimath itself. Plurimath correctly stores the symbol information; the issue is how moxml/Ox serializes that information to XML output.