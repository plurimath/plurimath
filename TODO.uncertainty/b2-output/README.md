# B2 — Six outputs (#493)

Dependency: B1 and signed B0 format strings/projections; implements C2–C7 output acceptance. AsciiMath output is included now, input remains blocked until B4.

| Task | Touchpoints and observable result | Effort (person-days) |
|---|---|---|
| B2.1 | Proposed `lib/plurimath/math/function/uncertainty.rb`: `to_asciimath(options:)`, `to_latex(options:)`, `to_html(options:)`, `to_unicodemath(options:)` follow exact signed cases | 3–5 |
| B2.2 | Same node: `to_mathml_without_math_tag(intent, options:)`, `to_omml_without_math_tag(display_style, options:)`, with signed structure, units and metadata behavior | 2–4 |
| B2.3 | Proposed `spec/plurimath/math/function/uncertainty_spec.rb` and `spec/plurimath/math/formula/uncertainty_spec.rb`; existing `lib/plurimath/math/formula.rb` delegation and intent postprocessing, modify only if needed | 2–3 |
| Total | | **7–12** |

Use B0's proposed `spec/plurimath/fixtures/uncertainty/contract.yml` as independent golden expectations. Assert all six renderers on direct nodes **and** Formula wrappers/nested expressions, default/options, parentheses, numeric spelling/exponents/locale, selected unit placement and metadata loss/error cases. MathML with and without intent must survive Formula postprocessing and have the signed meaning/projection; output must not accidentally turn ordinary `Pm` into a measurement.

Planned commands from Plurimath root:

```sh
bundle exec rspec spec/plurimath/math/function/uncertainty_spec.rb spec/plurimath/math/formula/uncertainty_spec.rb spec/plurimath/math/formula/intent_encoding_spec.rb
bundle exec rake spec
```

Exit: all six output cells for every selected semantic variant pass; any loss exactly matches the signed projection. Record cases/head/results. No round-trip or AsciiMath-input completion claim yet. Status pending; next B3 reader verification and B4 after A4.
