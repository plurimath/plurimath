# B1 — Model (#493)

Dependency: approved B0 contract and unit attachment; reconcile any A0 consumer migration before overlapping edits. Implements C1/C7. No AsciiMath grammar or `INPUT` vocabulary changes.

| Task | Exact existing/proposed touchpoints and result |
|---|---|
| B1.1 | Proposed `lib/plurimath/math/function/uncertainty.rb`, register in existing `lib/plurimath/math/function.rb`: implement signed variants/fields, validation and errors |
| B1.2 | Proposed `spec/plurimath/math/function/uncertainty_spec.rb`: equality over all signed semantics, unknown/supplied metadata, precision and unit policy; retain exact decimal spelling |
| B1.3 | Existing `Math::Core#cloned_objects`, `Math::Formula#==`/`#cloned_objects` integration and proposed `spec/plurimath/math/formula/uncertainty_spec.rb`: nested values/units clone independently, traverse correctly |

`Core#cloned_objects` constructs `self.class.new(nil)` before copying variables. Support that path or override cloning in the new node; do not weaken validation merely to make a broken clone succeed. Existing `Math::Number` stores strings; do not coerce to Float. Existing `Math::Function::Unitsml` has its own clone behavior; if selected as a child, test it directly and through Formula. Shared consumer edits need the A0 ownership decision; generic cleanup is excluded.

At phase entry expand exact constructor/spec cases from signed B0. Planned commands from the Plurimath root:

```sh
bundle exec rspec spec/plurimath/math/function/uncertainty_spec.rb spec/plurimath/math/formula/uncertainty_spec.rb
bundle exec rake spec
```

Exit: all signed valid/invalid/equality/clone cases pass, changed nested clones do not alter originals, existing suite stays green. Include explicit unequal standard/expanded and distinct lower/upper cases. Record commands/head/results; status pending. Next: B2 outputs and B3 inputs against this constructor revision.
