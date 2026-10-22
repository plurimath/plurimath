# B1 — Model (#493)

## What it delivers
The uncertainty node in `lib/plurimath/math/`, registered in
`math/function.rb`, with equality, cloning and the attributes the design note
names.

## Why here
Every format in B2 and B3 reads or writes this node, so it comes first and is
small.

## Risks and notes
- New files only, plus one autoload line. Nothing in `asciimath/`.
- No AsciiMath spelling is added to any `INPUT` table here (see the vocabulary
  rule in [cross-cutting](https://github.com/plurimath/amath/blob/feat/amath-extraction/TODO.plan/cross-cutting.md)).

## Exit criteria
Work items are written when B0 is approved.
- [ ] Node specs pass; `bundle exec rake spec` still passes.
