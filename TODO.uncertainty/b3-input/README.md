# B3 — MathML, OMML and UnicodeMath input (#493)

Dependency: approved B0 syntax and B1 constructor to start; B2 to finish round trips. Implements C3–C5/C7. Reconcile #430's HTML/UnicodeMath/Slice/dependency disposition and A0 migration baseline before touching overlapping files. LaTeX input is conditional, outside core estimates.

| Task | Existing touchpoints; proposed spec | Effort (person-days) |
|---|---|---|
| B3.1 | `lib/plurimath/mathml/translator.rb`, `Mathml::Translator#mml_to_plurimath` / `#mrow_to_mrow`, reached through `mathml/parser.rb`; proposed `spec/plurimath/mathml/uncertainty_spec.rb` | 2–4 |
| B3.2 | `lib/plurimath/omml/translator.rb`, `Omml::Translator#omml_to_plurimath` / `#translate_omml_node`, reached through `omml/parser.rb`; proposed `spec/plurimath/omml/uncertainty_spec.rb` | 2–4 |
| B3.3 | `lib/plurimath/unicode_math/parse.rb` (`UnicodeMath::Parse`) and `transform.rb` (`UnicodeMath::Transform`), reached through `parser.rb`; proposed `spec/plurimath/unicode_math/uncertainty_spec.rb` | 3–5 |
| B3.4 | B0 fixture projections, Formula round trips and existing input regressions | 1–2 |
| Total | | **8–15** |

Expand numbered tasks with exact signed grammar rules/tree keys after B0; do not guess new symbol names now. Parse the explicit canonical form for each selected variant into the same node. Plain `±`, ordinary `+-`, algebra and parentheses keep existing parse behavior. Reject malformed explicit measurement syntax rather than accepting a valid prefix. Specify parser error positions/context if this format exposes them. MathML must read the selected intent/structure convention; output with intent disabled has the separately signed projection. Assert unknown/supplied metadata and selected units without inference.

Test independent cited GUM examples, independently authored wire fixtures, negative cases and node → output → input equality (or the **exact** B0-approved projection). A reader/writer pair agreeing with each other is insufficient. Preserve numeric spelling/precision and ordinary Formula input behavior.

Planned commands from Plurimath root:

```sh
bundle exec rspec spec/plurimath/mathml/uncertainty_spec.rb spec/plurimath/omml/uncertainty_spec.rb spec/plurimath/unicode_math/uncertainty_spec.rb
bundle exec rspec spec/plurimath/mathml/parser_spec.rb spec/plurimath/omml/translator_spec.rb spec/plurimath/unicode_math/plurimath/unicodemath_transform_spec.rb spec/plurimath/unicode_math/plurimath/unicodemath_tests_spec.rb
bundle exec rake spec
```

If B0 selects LaTeX input, add exact tasks in existing `lib/plurimath/latex/parse.rb` / `transform.rb` and proposed `spec/plurimath/latex/uncertainty_spec.rb`, plus its focused command; add 2–4 person-days to the core total before implementation.

Exit: all three required readers meet the floor, independent fixtures and round trips pass, malformed forms reject, ordinary notation and existing specs pass. Status pending. Next B4 when A4 dependency is ready; no claim that #493 is complete yet.
