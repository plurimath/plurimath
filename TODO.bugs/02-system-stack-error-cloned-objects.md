# Fix SystemStackError in Formula#cloned_objects

## Problem
4 test failures with `SystemStackError: stack level too deep` in
`Plurimath::Math::Core#cloned_objects`. The `cloned_objects` method
recursively clones all values, but some formula structures create
infinite recursion.

## Affected specs (19 failures total)
- spec/plurimath/mathml_spec.rb:213 - MathML object round-trip
- spec/plurimath/mathml_spec.rb:778 - table with parentheses and sqrt
- spec/plurimath/mathml_spec.rb:1448 - mtable with frame/rowlines
- spec/plurimath/mathml_spec.rb:1713 - metanorma bipm input
- spec/plurimath/math_zone_spec.rb:675 - table math zone
- spec/plurimath/math_zone_spec.rb:4234 - table math zone
- spec/plurimath/integration/asciimath_spec.rb - 12 ogc/bipm/itu/jcgm examples

## Stack trace pattern
```
Core#cloned_objects → Formula#cloned_objects → Array#map →
Core#variable_value → Array#map → Core#cloned_objects → ...
```

## Root cause
`cloned_objects` in `lib/plurimath/math/core.rb:223` creates
`self.class.new(nil)` which triggers `Formula.new(nil)`. If the Formula
contains objects that reference back to the formula or create cyclic
structures, the recursion never terminates.

This is likely a pre-existing bug exposed by V4 parsing producing
different formula structures. Needs investigation of what formula
structure triggers the infinite recursion.

## Status: Open (pre-existing, needs investigation)
