# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Arg < BinaryFunction
        # --- Catalog documentation (see Plurimath::Documentation) ---
        DESCRIPTION = "An expression given an `arg` name for reference from an ancestor MathML `intent` annotation."
        REFERENCE = "https://www.w3.org/TR/mathml4/#mixing_intent"
        EXAMPLE = -> { new(sym("x"), sym("x")) }
        # --- end catalog documentation ---

        def to_mathml_without_math_tag(intent, options:)
          first_value = parameter_one.to_mathml_without_math_tag(intent,
                                                                 options: options)
          first_value.attributes[:arg] =
            Utility.html_entity_to_unicode(parameter_two.value)
          first_value
        end

        def to_unicodemath(options:)
          first_value = "(#{parameter_two&.to_unicodemath(options: options)} #{parameter_one&.to_unicodemath(options: options)})" if parameter_one || parameter_two
          "ⓐ#{first_value}"
        end
      end
    end
  end
end
