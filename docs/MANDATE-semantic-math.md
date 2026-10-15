# MANDATE — Plurimath as the semantic math engine for quantities, units, uncertainty, and constraints

**Issued by:** the Primmel language program (2026-10-15)
**Status:** the mandate — the work program this repository owns alongside
its presentation mission.

---

## 1. The mandate in one paragraph

Plurimath today is the universal math **presentation** engine: the Formula
model, the five-format translation, the renderers. This mandate extends the
Formula model from presentation to **semantics**: the expressions evaluate
over **quantities with units**, carry **uncertainties**, check
**dimensional coherence**, and evaluate **constraints to verdicts** — with
the same rigour the renderers bring to notation. Primmel (the modelling
language of the OIML SMART estate) becomes plurimath's first embedded
consumer: its requirement limits, its class laws, its derivations, and its
constraint assertions all evaluate through this engine.

## 2. Why plurimath

- The Formula model is already the universal tree — the semantic layer is a
  new reader and a new renderer over the same tree, not a new engine.
- UnitsML is already integrated (`asciimath2unitsml`) — the unit plane has
  its carrier.
- The multi-format renderers give the semantic results their presentation
  for free: an evaluated constraint renders to MathML, LaTeX, and Unicode
  with the same fidelity the notation has today.
- The JS/TS distributions (`plurimath-js`, `plurimath-ts`) exist — the
  embedded-consumer path (Primmel's TypeScript kernel) is already open.

## 3. The five work programs

### P1 — the quantity type system

- **QuantityValue**: `{ value: real, unit: UnitExpr, uncertainty:
  UncertaintyExpr? }` — the value, its unit expression, its optional
  uncertainty (P3).
- **UnitExpr**: the unit algebra — the SI base/derived units, the scaled
  units (kilo, milli), the compound units (`kg/m³`, `V/Hz`), the affine
  scales (degC — the offset units break the ring and are handled
  explicitly), and the UnitsML codes as the authority references.
- **Dimension vectors**: every UnitExpr reduces to its dimension vector;
  the coherence rules: the comparison requires the same dimensions, the
  arithmetic derives them (`m/s` × `s` → `m`), the conversion requires the
  registered factor/offset.
- **The type errors as data**: `DimensionMismatch{expected, got}`,
  `UnitNotConvertible{from, to}`, `UnknownUnit{code}` — the diagnostics are
  values, never exceptions-in-the-data-path.

### P2 — the expression evaluation

- **The grammar**: the precedence-climbing expression parser over the
  Formula tree (or the direct parse): `implies` < `or` < `xor` < `and` <
  comparison (`<= >= < > = ≠`) < additive < multiplicative < unary <
  primary (the literals, the bound names, the calls, the parenthesised
  groups). The booleans evaluate to `true/false`; `implies` short-circuits.
- **The scope**: `Scope` — the bindings `name → QuantityValue | Boolean |
  Series`; the parse-time resolution (an unbound name is a parse error);
  the scope composes (the containment: the member scopes chain).
- **The functions**: `abs, max, min, floor, ceil, round, sqrt, exp, ln,
  log, mod` + the aggregations over the series (P4): `max_of, min_of,
  mean_of, stddev_of, count_of` + the index access `series.at(t)`.
- **The evaluation is total and typed**: `evaluate(ast, scope) →
  BoolValue | QuantityValue | ErrorValue` — never an exception in the data
  path; the errors are the diagnostics.

### P3 — the uncertainty plane (GUM)

- **UncertaintyExpr**: the standard uncertainty `u`, the distribution (the
  type A: the statistics of a series; the type B: the stated distribution —
  rectangular, triangular, normal), the degrees of freedom.
- **The propagation**: the standard law for the independent components
  (`u_c = √(Σ (∂f/∂xᵢ · uᵢ)²)` — the partials evaluated symbolically over
  the expression AST or numerically at the point); the coverage factor `k`
  (declared, default 2); the expanded `U = k·u_c`.
- **The presentation**: the results render with their uncertainty (the
  `1,15 ± 0,06 V` form) through the existing renderers.
- **The boundary**: plurimath evaluates the budget's arithmetic; the budget
  itself (the components, their provenance) is the modelling language's —
  plurimath receives the components and returns the propagation. The GUM
  examples become the normative test vectors.

### P4 — the series and the aggregations

- **SeriesValue**: the ordered values with the optional index axis (the
  time, the position, the temperature) and the unit.
- The aggregations (P2's list), the index access, the slice by the
  predicate — the statistics the type A evaluation needs (`stddev_of`,
  `count_of`) close the loop: the type A uncertainties compute FROM the
  series the tests capture.

### P5 — the constraint evaluation and the verdicts

- **`evaluate_constraint(ast, scope) → ConstraintResult`**: `{ satisfied:
  bool, residual: QuantityValue? (the distance to the boundary), diagnostics:
  [...] }` — the residual is the verdict's evidence (how far from the limit,
  in the limit's own unit).
- **The guard evaluation**: the applicability expressions (`when { … }`)
  evaluate through the same path — the guards are constraints that return
  booleans.
- **The rendering of the verdicts**: the satisfied/unsatisfied constraint
  renders its evaluation trace (the substitution steps) — the explanation
  is the renderer's output too.

## 4. The contract with Primmel

- The Primmel kernel parses the model, resolves the bindings, and builds
  the `Scope`; plurimath parses the expression source, typechecks it against
  the scope, evaluates, and returns the typed result + the diagnostics.
- The expression grammar is **shared by contract**: the test vectors (the
  source → the AST → the result) are the cross-implementation normative
  suite; primmel-ts's TypeScript path and plurimath's Ruby reference both
  pass them.
- The distributions: the Ruby reference implementation here; the TS
  consumption through `plurimath-js`/`plurimath-ts` (existing) or the
  wasm — the vector suite is the integration gate either way.

## 5. The test vectors — the mandate's spine

1. **The GUM examples** (the standard's worked uncertainties — the type A
   and B, the combination, the expansion).
2. **The SI coherence suite** (the dimension reductions, the conversions,
   the affine traps: `degC` differences vs the absolute).
3. **The constraint suite** (the corpus's real limits: the R 60 MPE ranges,
   the R 134 regime laws, the r60 series creeps — each with the expected
   verdict and the residual).
4. **The diagnostics suite** (the dimension mismatches, the unknown units,
   the unbound names — each with the expected diagnostic value).
5. **The round-trip suite** (the parse → the render → the parse, the
   semantic-preserving, through every notation format).

## 6. The non-goals

- No symbolic algebra (the simplification, the solving) — the evaluation
  over the bound scopes only; the symbolic work stays with the CAS tools.
- No probability distributions beyond the GUM's evaluation forms — the
  Bayesian machinery is out of scope.
- No floating-point theology beyond `BigDecimal` where the comparisons are
  exact-critical (the MPE comparisons are boundary-exact — `<=` at the
  limit must be deterministic; `BigDecimal` or the rational policy is part
  of P1's spec).

## 7. The order and the sizing

1. P1 the quantity type system + the UnitExpr algebra — ~1 week.
2. P2 the evaluation + the scope + the diagnostics — ~1 week.
3. P5 the constraints + the residuals + the trace rendering — ~3 days.
4. P4 the series + the aggregations — ~3 days.
5. P3 the uncertainty (the propagation + the vectors) — ~1 week.
6. The contract suite with primmel-ts — continuous from P2.

**Total: ~4–5 weeks of focused work**, each program shippable
independently, the test vectors landing with each.
