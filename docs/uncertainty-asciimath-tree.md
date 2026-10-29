# AsciiMath uncertainty: parse tree contract (plurimath#493, B4)

The amath grammar turns `ustd(...)`, `uexp(...)` and `ucov(...)` into the tree
below. `Plurimath::Asciimath::Transform` (rule `uncertainty:`) turns it into
`Math::Function::Uncertainty`. Design: `docs/uncertainty.adoc`; cases:
`spec/plurimath/fixtures/uncertainty/contract.yml`; spec that checks this
tree against amath, the transform and `Math.parse`, and round-trips every case
through `to_asciimath`: `spec/plurimath/asciimath/uncertainty_spec.rb`.

## Shape

The node sits where any other operand sits, for example as the whole formula:

```ruby
{ expr: { sequence: { uncertainty: { uncertainty_class: "uexp", value: "10.0",
                                     magnitude: "0.3", coverage_factor: "2" } } } }
```

Every leaf under `uncertainty:` is a `Parslet::Slice` holding the text exactly
as written (no `{number: ...}` wrapper, no sign or whitespace). Keys absent from
the input are left out, never given as nil.

| Input | Keys under `uncertainty:` |
|---|---|
| `ustd(y, u)` | `uncertainty_class: "ustd"`, `value`, `magnitude` |
| `ustd(y(d))` | `uncertainty_class: "ustd"`, `value`, `concise_digits` |
| `uexp(y, U, k[, p])` | `uncertainty_class: "uexp"`, `value`, `magnitude`, `coverage_factor`[, `coverage_probability`] |
| `ucov(y, lo, hi, p[, kind])` | `uncertainty_class: "ucov"`, `value`, `lower`, `upper`, `coverage_probability`[, `interval_kind`] |
| `..., "unitsml(g)")` (last argument, any form) | adds `unit: "g"` (the text inside `unitsml(...)`) |

- `value` may carry a leading `-`; every other number is unsigned. The decimal
  marker is always a full stop, whatever the locale.
- `concise_digits` is the digit run inside the inner brackets: `ustd(1.230(4))`
  gives `value: "1.230"`, `concise_digits: "4"`. The transform turns it into
  `magnitude: 0.004`, `notation: :concise`.
- `unit` must not use the existing `{unitsml: ...}` key: that rule turns the unit
  into a rendered `Formula`, but the node keeps a `Math::Function::Unitsml`.

## Shared decimal exponents

The following call forms add an optional `shared_exponent` slice containing
signed exponent digits without `e`. No space is allowed before `e`:

```asciimath
ustd((3.85, 0.23)e4)
ustd(680(41)e-3)
uexp((3.85, 0.23)e+4, 2, 0.95)
ucov((1.024, 0.983, 1.088)e-3, 0.95, shortest)
```

The transform shifts the decimal point using strings, never floating-point
arithmetic. It scales value and magnitude, or value and both interval
endpoints; coverage factors and probabilities remain unchanged. Concise
magnitude is derived before applying the scale. The first two examples yield
`38500` with magnitude `2300`, and `0.680` with magnitude `0.041`.
Trailing decimal zeros remain significant stored text. Writers emit the
normalized existing uncertainty form, which can be read back into the same
model.

Existing calls omit this key and retain their behavior. Bare inline uncertainty
is part of the separate expression-language work in #513. To bound allocation,
the reader rejects a shared exponent that would expand a number beyond
1,000,000 decimal characters with `Errors::InvalidUncertainty`; no partial
number or rounded approximation is returned.

The shipped amath corpus `corpora/uncertainty-shared-exponent.yml` contains the
input trees and exact normalized model expectations checked by the reader specs.

## Interval kind spelling

`interval_kind` is a bare word: `shortest` or `symmetric`.
`probabilistically-symmetric` cannot be used, because AsciiMath reads the `-` as
minus. `symmetric` means the probabilistically symmetric coverage interval of
JCGM 101 §5.3.4 and maps to `:probabilistically_symmetric`. The output side
(`Uncertainty#to_asciimath`, which today writes `probabilistically-symmetric`)
must write `symmetric` so that output reads back.

## Errors

- Wrong argument count (for example `uexp(10.0, 0.3)`, no `k`): the call is
  not an uncertainty, and amath falls back to the letter reading it had before
  the uncertainty words (plurimath/amath#9). `uexp(10.0, 0.3)` reads as the
  symbol `u` followed by `exp(10.0, 0.3)`, as the contract cell
  `invalid.asciimath_missing_k` records; no error is raised. Should a tree with
  too few fields reach the transform anyway, the node raises
  `Errors::InvalidUncertainty`, which `Math.parse` reports as
  `Math::ParseError`.
- An unknown `uncertainty_class`, an unexpected key, a non-text leaf, both
  `magnitude` and `concise_digits`, non-digit `concise_digits` or an unknown
  `interval_kind` raise `Errors::InvalidUncertainty`.
- `+-`, `pm`, `±` and `1.230(4)` outside these three words never produce this
  tree.
