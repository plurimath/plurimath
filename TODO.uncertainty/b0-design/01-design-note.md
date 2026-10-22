# Task 01 — Sign the uncertainty contract

## Why and evidence

[#493](https://github.com/plurimath/plurimath/issues/493) requires a model and AsciiMath, MathML, OMML and UnicodeMath representation. It does not establish wire syntax or a constructor. The following choices are **proposals for B0**, not approved behavior. Keep reported quantities distinct from algebra and never infer confidence from a coverage factor alone.

Use [JCGM 100 §§7.2.2–7.2.3](https://www.iso.org/sites/JCGM/GUM/JCGM100/C045315e-html/C045315e_FILES/MAIN_C045315e/07_e.html) for standard and expanded reporting; use the actual §6.3.2 text for coverage-factor interpretation. For asymmetric intervals consult [JCGM 101 §5.3](https://www.bipm.org/documents/20126/2071204/JCGM_101_2008_E.pdf/325dcaad-c15a-407c-1105-8b7f322d651c), and cite the precise selected interval convention. A visual `+a/−b` layout alone does not define it.

## B0.1 — Select payload and examples

Proposed class/path: `Math::Function::Uncertainty`, `lib/plurimath/math/function/uncertainty.rb`. Choose either distinct magnitude/interval variants or named lower/upper fields before its constructor is frozen. Do not use a single unexplained `uncertainty` field with `kind: asymmetric`.

Candidate examples to convert into exact executable constructors (keyword names below are illustrative, not a promised API):

| Semantic case | Candidate fields | Decision and validation required |
|---|---|---|
| Standard | `value: Number("1.230"), category: :standard, magnitude: Number("0.004")` | Nonnegative absolute magnitude; source precision retained; absent coverage is unknown, not zero. Decide/reject nonsensical `k` metadata rather than guessing. |
| Symmetric expanded | `value: Number("10.0"), category: :expanded, magnitude: Number("0.3"), k: Number("2"), coverage_probability: nil` | Keep supplied positive `k`; do not calculate standard uncertainty or coverage. State whether unknown `k` is allowed and how it is rendered. |
| Asymmetric, pending convention | `value: Number("10"), lower: Number("0.2"), upper: Number("0.3"), interval_convention: ..., coverage_probability: ...` | Decide deviations versus endpoints, nonnegative components if deviations, category and meaning of coverage; distinguish equal-tailed/shortest interval if relevant. `k` is not derived from bounds. Decide whether supplied `k` is meaningful, rejected or unknown for this chosen variant. |

For every selected variant sign named fields, valid and invalid combinations, constructor signature, equality and clone results, and format round trips. Missing bounds, negative magnitudes, inconsistent variant fields, malformed coverage and unknown metadata need explicit outcomes/error types. Preserve unknown versus supplied metadata. If an asymmetric convention cannot be supported within this scope, record a maintainer issue-scope decision and remaining criterion; do not fabricate approval or relabel it standard uncertainty.

Choose numeric normalization and lexical preservation separately: `Number` currently preserves strings. Cover `1.23(4)` = absolute `0.04` versus `1.230(4)` = `0.004`, exponent scaling, trailing zeros and the active decimal marker. Distinguish last-digits notation from absolute parentheses `1.23(0.04)` in JCGM 100 §7.2.2; explicitly support or exclude the latter. Select a default rendering that avoids presenting bare ± as an unqualified standard uncertainty (§7.2.2). No Float conversion that loses required decimal context.

## B0.2 — Fill the acceptance contract

Proposed permanent fixture: `spec/plurimath/fixtures/uncertainty/contract.yml`. Assign stable cases `standard`, `expanded`, `asymmetric`, `concise_digits`, `absolute_parentheses`, `units`, `invalid`, and `ordinary_pm`. Store independent cited inputs as well as writer round trips so paired reader/writer errors cannot pass.

For **each** AsciiMath, MathML, OMML and UnicodeMath, specify one exact explicit canonical input/output for standard and symmetric expanded measurements and the selected asymmetric representation. Record the semantic projection: measured value, magnitude or ordered components, variant, lexical precision, supplied `k`, probability and unit. Value, magnitude/components and variant cannot be dropped by the minimum canonical form. Any precision, metadata or unit loss must be named, justified and explicitly approved; no silent conversion of expanded/asymmetric to standard. An unresolved required-language gap blocks completion of #493.

Choose MathML structure plus intent/semantic convention, including behavior with intent disabled and what ordinary MathML consumers display. Choose disjoint OMML/UnicodeMath encodings rather than recognizing an arbitrary adjacent `±` as measurement. AsciiMath's explicit spelling is designed here but implemented only in amath after A4. Record token/precedence/tree contract and ambiguity tests for B4. Do not extend current AsciiMath vocabulary while extraction is in progress.

For all **six** output formats (also LaTeX and HTML), fill every selected-variant cell with exact expected string/XML, supported options, default rendering and loss/error behavior. Optional aliases may be unsupported; the four required languages may not be entirely unsupported or output-only. LaTeX input is a separate yes/no decision; if selected, its grammar and tests are added as their own tasks.

Units decision has two parts: (1) node attachment, e.g. a `Math::Function::Unitsml` child, enclosing expression, or explicit initial exclusion, must be settled before B1; (2) whether current `unitsml` dependency suffices. If attachment is supported, sign a measured value plus unit example: B1 clone/equality; B2 placement/output; B3 non-Ascii input; B4 Ascii input. If dependency changes are necessary, identify unitsml-ruby owner/version/repository work and acceptance before scheduling; otherwise explicitly defer dependency changes and describe supported initial behavior. No implicit unit conversion or uncertainty arithmetic.

## B0.3 — Sign and preserve

Write approved semantics, constructors, default formats, exact loss table and errors in proposed `docs/uncertainty.adoc`; link it from `README.adoc`. Retain fixture schema/examples with it. Copy the [compact handoff](../README.md#copyable-cross-repository-handoff) into durable records, linking approved immutable revisions of amath `docs/parser-contract.adoc` and `docs/extraction-handoff.adoc` when available. Record unresolved A0 Slice/vocabulary decisions as dependencies, not approved outcomes.

Done when B0's checklist passes, the maintainer approval link and revision are recorded, and B1–B4 can implement the signed examples without inventing syntax or scientific meaning. All these actions remain planned.
