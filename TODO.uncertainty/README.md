# Plan: measurement uncertainty (#493)

Modelling measurement uncertainty, as the GUM (JCGM 100) describes it, in
Plurimath's model and in AsciiMath, MathML, OMML and UnicodeMath
([#493](https://github.com/plurimath/plurimath/issues/493)).

> This plan lives on the `feat/gum-uncertainty` branch only. `/TODO.*/` is
> ignored on `main`, so it was added here deliberately for review and is
> removed before this branch merges.

## Blocked on amath for AsciiMath input

AsciiMath *input* for uncertainty (B4) is blocked until the AsciiMath parser
has moved into [`plurimath/amath`](https://github.com/plurimath/amath)
([#494](https://github.com/plurimath/plurimath/issues/494)). It will be added
to the amath grammar, not to Plurimath's current parser, so it is not written
twice. Everything else here — design, model, output for every format including
AsciiMath, and input for the other formats — goes ahead in parallel.

The rules both issues share — which files each side may edit, the symbol
vocabulary, sync points, open decisions — are in amath's plan:
[cross-cutting](https://github.com/plurimath/amath/blob/feat/amath-extraction/TODO.plan/cross-cutting.md)
and
[open decisions](https://github.com/plurimath/amath/blob/feat/amath-extraction/TODO.plan/open-decisions.md).

## Phases

| Phase | Delivers | Waits for | Status |
|---|---|---|---|
| [B0 — Design](b0-design/) | Design note approved by Ronald | — | ▶ next |
| [B1 — Model](b1-model/) | The uncertainty node | B0 | planned |
| [B2 — Output](b2-output/) | Every format writes it | B1 | planned |
| [B3 — Input](b3-input/) | MathML, OMML, UnicodeMath (and LaTeX if B0 says) read it | B1 to start, B2 to finish | planned |
| [B4 — AsciiMath input](b4-asciimath-input/) | AsciiMath reads it; every acceptance-table cell passes → **#493 done** | B2, B3, **amath (#494) released and merged** | blocked |

## How this is organised

Every phase is a directory whose `README.md` answers four questions in order:
*what it delivers*, *why here*, *risks and notes*, *exit criteria*. A phase
gains numbered work items (`## Why`, `## Scope`, `## Done when`) when work on it
starts; only B0 has items so far.

## Why this order

1. **B0 before any code** because Plurimath already reads `+-` as a plain ±
   (`Math::Symbols::Pm`). Which inputs mean a measurement, and how each format
   writes it, has to be agreed before either side is built.
2. **Model, then output, then input**, because every format shares one model,
   and input can only be checked by round trip once output exists.
3. **AsciiMath input last**, for the amath reason above.
