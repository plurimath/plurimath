# Serialized quantity requests

Require `plurimath/evaluation_request` and call
`Plurimath::EvaluationRequest.call(json)` with schema
`plurimath.evaluate.quantity/1`. The AST uses the same number, variable,
unary and binary nodes as the [numeric profile](numeric-request.md).
The quantity profile accepts exact decimal strings and quantity bindings
such as `{"value":"2","unit":"kV"}`. Set `difference: true` on an
already difference-typed binding. Optional `convert_to` requests an
additional result in the target unit.

The result contains the quantity and, when requested, its converted
form. Each quantity carries its exact rational magnitude, canonical
magnitude, dimensional powers, scale and resolved unit terms. Parser
refusals carry a byte offset and the parser's expectations. Division
by zero returns an indeterminate outcome. A conversion factor produced
as a float is refused rather than presented as exact.
