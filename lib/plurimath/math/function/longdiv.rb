# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Longdiv < UnaryFunction
        # --- Catalog documentation (see Plurimath::Documentation) ---
        DESCRIPTION = "Sets its argument under a long-division bracket."
        REFERENCE = "https://en.wikipedia.org/wiki/Long_division"
        EXAMPLE = -> { new(sym("x")) }
        # --- end catalog documentation ---

        def to_asciimath(options:)
          asciimath_value(options: options)
        end

        def to_latex(options:)
          latex_value(options: options)
        end

        def to_mathml_without_math_tag(intent, options:)
          XmlHelper.update_nodes(
            ox_element("m#{class_name}"),
            mathml_value(intent, options: options),
          )
        end

        def to_omml_without_math_tag(display_style, options:)
          omml_value(display_style, options: options)
        end

        def to_unicodemath(options:)
          parameter_one&.to_unicodemath(options: options)
        end

        def line_breaking(obj)
          custom_array_line_breaking(obj)
        end
      end
    end
  end
end
