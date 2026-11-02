# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Scarries < UnaryFunction
        # --- Catalog documentation (see Plurimath::Documentation) ---
        DESCRIPTION = "Marks carries or borrows over a row in elementary arithmetic layout."
        REFERENCE = "https://www.w3.org/TR/mathml4/#presm_mscarries"
        EXAMPLE = -> { new(sym("x")) }
        CATALOG_FORMAT_LIMITATIONS = {
          asciimath: {
            status: :limited,
            notes: ["Carry positioning is omitted; only the carried expression is emitted."],
          },
          latexmath: {
            status: :limited,
            notes: ["Carry positioning is omitted; only the carried expression is emitted."],
          },
          omml: {
            status: :limited,
            notes: ["Carry positioning is omitted; only the carried expression is emitted."],
          },
        }.freeze
        # --- end catalog documentation ---

        def to_asciimath(options:)
          asciimath_value(options: options)
        end

        def to_latex(options:)
          latex_value(options: options)
        end

        def to_mathml_without_math_tag(intent, options:)
          XmlHelper.update_nodes(
            ox_element("mscarries"),
            mathml_value(intent, options: options),
          )
        end

        def to_omml_without_math_tag(display_style, options:)
          omml_value(display_style, options: options)
        end
      end
    end
  end
end
