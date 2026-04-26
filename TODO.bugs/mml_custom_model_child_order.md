# Proposal: Fix Custom Model Deserialization Child Order for Binary Operators

## Problem Description

When using the mml gem's custom model feature to substitute element classes (e.g., mapping `Mml::V4::Mover` to a custom `Overset` class), the child elements are being passed to the custom model's constructor in **reversed order** compared to their document order.

## Expected Behavior

For MathML `<mover>` element:
- First child = base (the element being overscored)
- Second child = overscript (the accent mark)

When parsing `<mover><mi>θ</mi><mi>d</mi></mover>`:
- `mi[0]` = θ (base)
- `mi[1]` = d (overscript)

The custom model `Overset.new(base, overscript)` should receive:
- `parameter_one` = θ
- `parameter_two` = d

## Actual Behavior

The custom model `Overset` receives children in **reversed order**:
- `parameter_one` = d (should be θ)
- `parameter_two` = θ (should be d)

## Clarification: This is NOT a lutaml-model bug

Lutaml-model has confirmed this is not an issue in their gem. The problem is entirely within the **mml gem** and how it sets up and uses custom models.

## Root Cause Analysis

### Investigation Steps

1. **Parsing without custom models:**
   ```ruby
   parsed = Mml.parse(mathml, namespace_exist: true, version: 4)
   mover = parsed.instance_variable_get(:@mover_value).first
   # mover.mi_value[0].value = "θ" (correct - base first)
   # mover.mi_value[1].value = "d" (correct - overscript second)
   ```

2. **Parsing with custom models:**
   ```ruby
   Mml::V4::Configuration.custom_models = { Mml::V4::Mover => Overset }
   parsed = Mml.parse(mathml, namespace_exist: true, version: 4)
   overset = parsed.value.first
   # overset.parameter_one.value = "d"  (WRONG - should be "θ")
   # overset.parameter_two.class = Theta (WRONG - should be "d")
   ```

3. **Custom model setup in mml gem:**
   ```ruby
   # From mml gem's context_configuration.rb:
   def custom_models=(models_hash)
     models_hash.each do |klass, model|
       klass.model(model)
     end
   end

   # This calls lutaml-model's model method:
   # From lutaml-model serialize/initialization.rb:
   def model(klass = nil)
     if klass
       @model = klass
       add_custom_handling_methods_to_model(klass)
     else
       @model
     end
   end
   ```

4. **The fix must be in mml gem:**
   When `klass.model(custom_model)` is called, the mml gem should ensure that when the custom model is instantiated during deserialization, the child elements are passed in document order. The issue is that the mml gem's element attribute definitions (e.g., `element "mover"` with child `mi_value`) are not being properly respected when the custom model substitution is applied.

   Specifically, the mml gem's `ContextConfiguration#custom_models=` sets up the model substitution, but it does not ensure that the original element's `element_order` or child element mappings are preserved for the custom model. When lutaml-model instantiates the custom model via its `from_xml` or similar deserialization path, it passes children in an order that may not match the MathML document order.

### Key Finding

The issue is in **how the mml gem sets up the model substitution**, not in lutaml-model itself. When `Mml::V4::Mover.model(Overset)` is called:

1. Lutaml-model stores `@model = Overset`
2. During XML deserialization, lutaml-model uses its own logic to map XML children to constructor arguments
3. The mml gem's element definitions (which define child element order via `element_order` or similar) are not being communicated to the custom model

The fix should be in `ContextConfiguration#custom_models=` — after calling `klass.model(model)`, the mml gem should also ensure that the custom model class inherits or mirrors the original element's child element ordering information.

## Affected Elements

This issue affects all binary MathML elements when using custom models:
- `<mover>` → Overset (base, overscript)
- `<munder>` → Underset (base, underscript)
- `<mover>` and `<munder>` combined in `<munderover>` → Underover (base, underscript, overscript)
- `<msup>` → Power (base, superscript)
- `<msub>` → Base (base, subscript)

## Expected Fix

The fix must be in the **mml gem** — specifically in `ContextConfiguration#custom_models=` or the related element deserialization logic. When setting up a custom model substitution, the mml gem must ensure that the custom model receives child elements in MathML document order.

### Specific Fix Location

In `lib/mml/context_configuration.rb`, the `custom_models=` method should be updated to preserve child element ordering when setting up the model substitution. One approach:

1. After calling `klass.model(model)`, copy or alias the original element's `element_order` or child-getting logic to the custom model
2. Or, intercept the deserialization of elements with custom models to explicitly pass children in document order

## Test Case

```ruby
# Setup
require "mml"
class Overset < BinaryFunction
  def initialize(base = nil, overscript = nil)
    super(base, overscript)
  end
end
Mml::V4::Configuration.custom_models = { Mml::V4::Mover => Overset }

# MathML: <mover><mi>θ</mi><mi>d</mi></mover>
# Expected: base=θ, overscript=d
# Actual: base=d, overscript=θ (BUG!)

mathml = <<~MATHML
<math xmlns="http://www.w3.org/1998/Math/MathML">
  <mover>
    <mi>θ</mi>
    <mi>d</mi>
  </mover>
</math>
MATHML

parsed = Mml.parse(mathml, namespace_exist: true, version: 4)
overset = parsed.value.first
raise "Bug: children reversed!" unless overset.parameter_one.value == "θ"
```

## Impact

This bug affects any application using the mml gem's custom model feature to substitute element classes, particularly when:
- Building domain-specific MathML parsers (like plurimath)
- Converting MathML to other formats
- Processing mathematical content with accent marks, subscripts, superscripts, etc.

## References

- MathML Specification: https://www.w3.org/TR/MathML3/chapter3.html
- mml gem: https://github.com/metanorma/mml
- lutaml-model gem: https://github.com/lutaml/lutaml-model (confirmed: not the source of this bug)
