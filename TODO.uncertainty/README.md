# Plan: measurement uncertainty (#493)

Represent reported measurement uncertainty in the model and math languages required by [#493](https://github.com/plurimath/plurimath/issues/493): AsciiMath, MathML, OMML and UnicodeMath. Provide six outputs: those four, LaTeX and HTML. This is representation and conversion, with no uncertainty propagation, statistical estimation or calculation of `U`, `k` or coverage probability. Ordinary `+-` / `±` retains `Math::Symbols::Pm` semantics.

The baseline is Plurimath `ae20be111a26fdd988c58be0bfb2b7f6fe6e352f`; no uncertainty node or format convention is established there. B0 resolves the design before implementation. This plan is kept on `main` for visibility (`/TODO.*/` is otherwise ignored here) and is removed when #493 is finished, **only after** its approved contracts and acceptance fixtures are retained in the permanent homes below.

## Completion floor and acceptance mapping

The proposed minimum below must be confirmed in B0; it is a requirement for implementation, not a claim of observed support or approved syntax. A required language cannot be labelled wholly unsupported or output only and still satisfy #493. If it cannot meet the floor, obtain an explicit issue-scope decision and record the outstanding gap before claiming completion.

| Criterion | Required outcome | Work and proof |
|---|---|---|
| C1 model | Measured value, absolute standard magnitude, symmetric expanded magnitude and supplied metadata have distinct representations; asymmetric payload is decided before freezing the node | B0 semantic examples; B1 equality, validation, cloning and Formula tests |
| C2 AsciiMath | Emit and recognize one explicit canonical measurement form for each supported semantic variant; preserve value, magnitude/components, variant and declared precision; preserve supplied metadata or document an approved exact loss | B0 signed wire examples; B2 output; B4 installed dependency round trips and independent examples |
| C3 MathML | Same minimum in one agreed structure/semantic convention, with MathML intent handling specified | B0, B2 Formula output, B3 translator input |
| C4 OMML | Same minimum in one agreed explicit structure; ordinary algebra must not be reclassified | B0, B2 output, B3 translator input |
| C5 UnicodeMath | Same minimum in one explicit canonical form, disjoint from ordinary `±` | B0, B2 output, B3 grammar/transform input |
| C6 six outputs | All six serializers produce the agreed rendering for supported variants, with explicit loss behavior | B2 golden fixtures and Formula traversal; B4 final replay |
| C7 preservation and handoff | Existing algebra, parentheses, numeric spelling, parser contracts and supported units remain compatible; signed contracts survive plan removal | B1–B4 preservation suites; durable docs and fixtures |

Standard and symmetric expanded uncertainty belong in the minimum. Asymmetric reporting remains planned scope, but its scientific meaning, payload and notation are a B0 decision; exclusion or reduction requires an explicit scope decision, not an unsupported table cell. LaTeX input and additional notation aliases are optional and cannot replace C2–C5. Exact strings/XML, metadata projections and errors must be signed before dependent code begins; see [B0](b0-design/01-design-note.md).

## Phases and dependencies

All statuses are pending; no implementation or application tests are claimed.

| Phase | Delivers | Dependency | Status |
|---|---|---|---|
| [B0](b0-design/) | Approved semantic and required-format contract | — | next |
| [B1](b1-model/) | Node, equality, clone, Formula integration | B0 | pending |
| [B2](b2-output/) | Six outputs | B1 | pending |
| [B3](b3-input/) | MathML, OMML, UnicodeMath inputs | B0/B1 to start; B2 to finish | pending |
| [B4](b4-asciimath-input/) | amath grammar, release, dependency integration | B2/B3 and #494 A4 released/merged | blocked |

Optional LaTeX input is outside the core scope. UnitsML dependency changes are scoped in B0 if required. B2 and B3 may overlap after their shared contracts are frozen. Expand numbered tasks at each phase entry without weakening C1–C7.

## Copyable cross-repository handoff

The shared rules are canonical in amath's [cross-cutting plan](https://github.com/plurimath/amath/blob/main/TODO.plan/cross-cutting.md) and [decisions](https://github.com/plurimath/amath/blob/main/TODO.plan/open-decisions.md). This compact contract must be reconciled with those records at B0/A0 and copied into permanent docs; a mutable branch link is insufficient evidence of a signed decision.

- A owns extraction, grammar/artifact and parser runtime in amath through A4. Plurimath retains its AsciiMath transform. B owns Plurimath uncertainty work through B3 and **also** the subsequent amath uncertainty grammar, regeneration/tests/version/release and Plurimath dependency/transform work in B4. B never adds uncertainty to the old Plurimath AsciiMath grammar.
- Freeze A's oracle before new syntax. Do not add AsciiMath words through node `INPUT` tables before A4. Vocabulary fingerprints include word/category mapping, effective ordering and generated grammar inputs, distinct from artifact checksums. B4 extends the signed configuration and replays the unchanged corpus.
- A0 chooses a real `Parslet::Slice` boundary adapter or explicitly authorized consumer migration. If migration is needed, A updates the exact shared file ownership list before A3; B reconciles any affected `math/number.rb`, `math/function/unary_function.rb`, `utility.rb`, `asciimath/utility.rb` or transform edits against that decision. B does not assume a string-equivalent leaf is compatible. Preserve leaf class, empty/text behavior, offsets and conversions.
- A3's PR removes the browser update/test path; Ronald's review of it decides. [#430](https://github.com/plurimath/plurimath/pull/430) overlaps B1/B3 files but is not built on: it waits until #493/#494 merge and is then rebased. B uses `ae20be11` without #430 as its baseline. Do not remove Parslet while the adapter or other parsers need it; Opal implementation remains excluded.
- A4 supplies released amath version, commit/artifact checksum, corpus pin/context, installed-gem engine/error contract and compatibility decision. B4 starts only after that release and Plurimath switch merge. `ae20be11` is the Plurimath oracle, not amath's repository base; record each repository's actual merge/release SHA.

## Durable documentation and next action

Proposed permanent Plurimath home: `docs/uncertainty.adoc`, linked from existing `README.adoc`; executable cases in proposed `spec/plurimath/fixtures/uncertainty/contract.yml` and phase specs. Retain meanings, constructors, exact required/optional format examples, metadata losses, unit policy, errors, numeric context and B4 handoff. amath retains API/engine/Slice/vocabulary contracts in proposed `docs/parser-contract.adoc` and extraction pins/coordination in `docs/extraction-handoff.adoc`. Replace historical branch references with immutable commit links once approved. Check all retained links and fixture references before deleting TODO scaffolding.

Next action: execute B0 task 01: fill and approve semantic examples, required-format wire forms and projections, asymmetric decision, units attachment, optional LaTeX input and durable handoff. Record the approving issue/PR decision link and revision; approval is pending. No B1 constructor or serializer contract is frozen yet.
