# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Mlabeledtr < BinaryFunction
        # --- Catalog documentation (see Plurimath::Documentation) ---
        # parameter_one is the row content, parameter_two the label (e.g. an
        # equation number). Only MathML and UnicodeMath are overridden; the
        # other formats fall back to the generic binary rendering.
        DESCRIPTION = "A table row carrying a label, such as an equation number."
        REFERENCE = "https://www.w3.org/TR/MathML3/chapter3.html#presm.mlabeledtr"
        EXAMPLE = -> { new(sym("x"), Text.new("1")) }
        # --- end catalog documentation ---

        def to_mathml_without_math_tag(intent, options:)
          table = ox_element("mtable")
          mlabeledtr = ox_element(class_name)
          labeledtr_td(mlabeledtr,
                       parameter_two.to_mathml_without_math_tag(intent,
                                                                options: options))
          labeledtr_td(mlabeledtr,
                       parameter_one.to_mathml_without_math_tag(intent,
                                                                options: options))
          table << mlabeledtr
        end

        def to_unicodemath(options:)
          "#{parameter_one&.to_unicodemath(options: options)}##{parameter_two&.value}"
        end

        protected

        def labeledtr_td(tr, value)
          tr << (ox_element("mtd") << value)
        end
      end
    end
  end
end
