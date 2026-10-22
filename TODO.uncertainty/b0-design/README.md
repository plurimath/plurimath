# B0 — Design (#493)

## What it delivers
A design note, approved by Ronald, that says exactly what "uncertainty" means
in Plurimath: which notations, how the model holds them, and how every format
writes and reads them, with GUM examples as the acceptance cases.

## Why here
#493 is three lines long. Plurimath already reads `+-` as a plain ± symbol, so
"support uncertainty" cannot be built until it is clear which inputs are a
measurement and which are ordinary algebra. Every later B phase is checked
against this note.

## Risks and notes
- MathML has no element for uncertainty, so the note proposes a convention
  (structure plus `intent`), and states what other tools will see.
- Some formats will not hold all the metadata (kind, coverage factor). The note
  says, per format, what is kept and what is lost, so tests check the right
  thing.
- UnitsML may or may not be involved (open decision 7).

## Exit criteria
- [ ] [01 — design note](01-design-note.md) written.
- [ ] Ronald has approved it, or his changes are made.
- [ ] Open decisions 4–7 settled.
