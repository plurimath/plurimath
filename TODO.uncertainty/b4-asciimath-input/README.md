# B4 — AsciiMath input (#493)

## What it delivers
AsciiMath input for uncertainty, added to the amath grammar, released in a new
amath version, and read by Plurimath. With it, every format's
acceptance-table cells pass, and #493 is done.

## Why here
Waits for A4. Adding this to the old Parslet parser would mean writing it twice
and moving A's parity baseline while A is porting against it.

## Risks and notes
- Starts with rebasing `feat/gum-uncertainty` onto `main` after A4 merges.
- The new syntax must not change how existing `+-` or parentheses parse; A's
  corpus proves that.
- Needs an amath release and a raised minimum amath version in Plurimath's
  gemspec — both lane B's to do.

## Exit criteria
- [ ] amath's corpus gains the new cases, with the old ones unchanged.
- [ ] amath released with the new syntax.
- [ ] AsciiMath round trips pass; the full suite passes.
- [ ] Every B1–B3 exit criterion still holds.
- [ ] Plurimath PR merged. → **#493 done.**
