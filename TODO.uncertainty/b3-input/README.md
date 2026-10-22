# B3 — Input (#493)

## What it delivers
MathML, OMML and UnicodeMath input recognise the notations the design note
defines, and LaTeX too if open decision 6 says so.

## Why here
After the output side exists, each input can be checked by round trip:
node → output → input → the same node.

## Risks and notes
- Must not change how existing inputs parse: plain `±` stays `Pm`.
- MathML input reads the convention B0 chose, including `intent`.

## Exit criteria
Work items are written when B3 starts. B3 can start after B1, but its
round-trip gate needs B2.
- [ ] Round trips pass for each format, with full equality where the format is
      lossless and the B0-approved reduced form where it is not.
- [ ] All existing specs still pass.
