# B2 — Output (#493)

## What it delivers
`to_mathml`, `to_omml`, `to_unicodemath`, `to_latex`, `to_asciimath` and
`to_html` for the uncertainty node, matching the design note's acceptance
table.

## Why here
Output is shared by every input path, so it comes before input. AsciiMath
*output* belongs here; only AsciiMath *input* waits for #494.

## Risks and notes
- Tested on nodes built directly, since input does not exist yet.
- AsciiMath support is labelled partial until B4.

## Exit criteria
Work items are written when B2 starts.
- [ ] Every output cell of the acceptance table passes.
