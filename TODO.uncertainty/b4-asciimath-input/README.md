# B4 — AsciiMath input and final integration (#493)

B owns this **cross-repository** phase: amath grammar/artifact/tests/version and release coordination, then Plurimath transform/dependency/acceptance. Wait for B2/B3 and #494 A4's released amath and merged Plurimath switch. Do not alter the old Plurimath parser or extraction oracle to add uncertainty earlier. Implements C2/C7 and verifies C1–C6 remain satisfied.

## Entry handoff and work

Record actual Plurimath main/A4 merge SHA and amath release SHA/version, artifact checksum, corpus revision/context, vocabulary fingerprint, Slice decision and installed-gem engine/error policy from retained amath `docs/parser-contract.adoc` and `docs/extraction-handoff.adoc`. The original Plurimath oracle `ae20be11` is not an amath base. Rebase B onto the actual integrated main; resolve only relevant overlaps against A0/B0 contracts.

| Task | Exact/proposed touchpoints and result | Effort (person-days) |
|---|---|---|
| B4.1 | Reconcile entry pins, ownership and signed AsciiMath token/tree/precedence contract; update proposed Plurimath `docs/uncertainty.adoc` | 1–2 |
| B4.2 | amath proposed `grammars/asciimath.parg` and generated artifact selected by A0/A2, proposed `spec/amath/uncertainty_spec.rb`, existing/proposed `scripts/check.rb` parity corpus; add only signed explicit measurement syntax | 2–4 |
| B4.3 | amath packaged-gem verification, version/release coordination; Plurimath existing `plurimath.gemspec` and `lib/plurimath/asciimath/transform.rb`, proposed `spec/plurimath/asciimath/uncertainty_spec.rb` | 2–3 |
| B4.4 | Integrated floor replay, full suite, permanent docs/fixture/link check and release handoff | 1–2 |
| Total | | **6–11** |

A2 proposes `grammars/asciimath.parg`; A0/A2 confirm that source path, the artifact path and regeneration command; before B4.2 starts, replace that discovery target with their retained paths/symbols/commands and a pinned base. Do not invent a pre-existing amath grammar API. The completion condition is a reproducibly regenerated packaged artifact with new accepted/rejected typed trees on both supported engines and unchanged old corpus behavior.

Retain ordinary `+-` as `Pm`; last-digits parentheses, absolute parentheses (if selected), ordinary grouping, decimal contexts and trailing invalid input must not change accidentally. Compare each engine to the frozen A1 success **and rejection** oracle, with signed leaf class/text/offset and raw/preprocessed byte/character position policy. Same wrong trees on both engines are a failure. Extend vocabulary/configuration fingerprints for categories/order/generated tables; keep artifact checksum separate. Include independent GUM cases and asymmetric ordering if selected.

## Planned checks and release sequence

Commands are planned, not executed. A2 proposes the `scripts/check.rb` runner. The oracle variable identifies A1's clean pinned Plurimath checkout. From the amath root after that handoff:

```sh
bundle exec ruby scripts/check.rb --plurimath-checkout "$PLURIMATH_ORACLE"
bundle exec rspec spec/amath/parser_spec.rb spec/amath/artifact_spec.rb spec/amath/uncertainty_spec.rb
gem build amath.gemspec
```

Expand B4.3 with A4's exact installed-gem and regeneration commands before execution; verify the built uncertainty artifact under native and Ruby engines where supported, documented no-native behavior, and loud failure for missing/malformed/checksum-invalid/unsupported artifacts. Record actual engine used, package/version and results. Publish the new amath release through its release owner/authorization, then raise Plurimath's minimum amath version and verify against that released package. A source checkout alone cannot satisfy this dependency gate.

From the Plurimath root after installing the released dependency:

```sh
bundle install
bundle exec rspec spec/plurimath/asciimath/uncertainty_spec.rb spec/plurimath/math/function/uncertainty_spec.rb spec/plurimath/math/formula/uncertainty_spec.rb
bundle exec rake spec
```

## Exit and durable handoff

- [ ] Actual grammar source/artifact paths, engines, checksums, corpus pin and regeneration/package commands retained in amath permanent docs; new grammar released, release owner/version recorded.
- [ ] Plurimath uses that release; independent AsciiMath inputs and signed round trips meet C2 and retain precision/metadata/unit projections.
- [ ] Existing corpus accepted/rejected results, leaf/error contracts and ordinary algebra/parentheses pass unchanged; B1–B3 criteria still pass.
- [ ] All four required languages meet their signed minimum in both directions; all six outputs pass; required scope exceptions are resolved explicitly, not hidden by table labels.
- [ ] `docs/uncertainty.adoc`, fixtures, README links and immutable dependency handoff survive deletion of temporary TODO files. Verify links from a checkout without the plans/feature branches.
- [ ] Integrated implementation checks/required CI and final branch review are complete; release and merge documentation describes supported subset and losses. Only then is #493 implementation complete; issue closure is a separate authorized action.

Status blocked on A4 and B2/B3. Next action now is B0; at B4 entry, read the retained A4 handoff and replace the bounded discovery items above with pinned executable instructions.
