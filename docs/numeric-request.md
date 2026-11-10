# Numeric JSON requests

The `plurimath.evaluate.numeric/1` profile accepts a closed numeric AST and exact decimal bindings. Ruby exposes `Plurimath::EvaluationRequest.call(json)` after `require "plurimath/evaluation_request"`; TypeScript exposes `evaluateRequest(json)` from `@plurimath/plurimath-ts`. Both return canonical JSON strings.

```json
{"schema":"plurimath.evaluate.numeric/1","ast":{"type":"binary","operator":"/","left":{"type":"variable","name":"x"},"right":{"type":"number","text":"3"}},"bindings":{"x":"0.30"}}
```

The result is the exact rational `1/10`. Decimal strings retain literal significance in the document AST. Explicit binary nesting determines grouping, including division and powers; textual parser locale and associativity do not enter this interface.

The AST forms are `number` with `text`, `variable` with an ASCII `name`, `binary` with `operator`, `left` and `right`, `unary` with `operator` and `operand`, and `call` with `name` and `argument`. Binary operators are `+`, `-`, `*`, `/`, `^`; unary operators are `+`, `-`; calls are `sqrt`, `sin`, `cos`, `exp`, `ln`, `abs`. Unknown fields/forms are refused. The maximum AST nesting is 64. Bindings are exact decimal strings.

`mode` is `strict` by default, or `approximate`. Optional `guard_digits` is an integral JSON number from 1 through 1000, or null. Strict evaluation can defer at an accuracy boundary; the response carries that boundary and the original unevaluated AST. Guarded operations follow the existing evaluator's supported functions and precision semantics.

Responses stamp the shared behavior versions `plurimath.numeric/1` and `plurimath.numeric-ast/1`. Binding package versions are independent. Keys are sorted. Integer and rational components use decimal strings; decimal values carry their precision; floats use 16 hexadecimal digits of network-order IEEE binary64, preserving signed zero. Typed errors carry stable codes without platform-dependent messages.

The numeric profile delegates arithmetic to the existing evaluator. Quantity registers, uncertainty budgets, series, conformance limits, boolean logic and collection iteration require additional profiles and are refused here. This profile is an initial part of the expression/evaluator programme, not its complete conformance corpus.

The checked shared vectors cover exact arithmetic, explicit grouping, decimal significance, strict/guarded/approximate boundaries and typed refusals. The ordinary document AST is available through Ruby `formula(ast)` and TS `formulaFromRequestAst(ast)`; grouping is checked through AsciiMath, LaTeX, MathML and OMML rendering. Serialized evaluation uses its own deferred AST representation and does not consult ambient configuration, unit data, files or environment variables after library initialization.
