# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Rule < TernaryFunction
        # --- Catalog documentation (see Plurimath::Documentation) ---
        DESCRIPTION = "A typographic rule — a filled rectangle used for spacing or lines, as in LaTeX's rule."
        REFERENCE = "https://latexref.xyz/_005crule.html"
        EXAMPLE = -> { new(sym("5pt"), sym("5pt"), sym("5pt")) }
        # --- end catalog documentation ---

        FUNCTION = {
          name: "rule",
          first_value: "first argument",
          second_value: "second argument",
          third_value: "third argument",
        }.freeze

        def to_asciimath(**)
          ""
        end

        def to_latex(options:)
          first_value = "[#{parameter_one.to_latex(options: options)}]" if parameter_one
          second_value = "{#{parameter_two.to_latex(options: options)}}" if parameter_two
          third_value = "{#{parameter_three.to_latex(options: options)}}" if parameter_three
          "\\rule#{first_value}#{second_value}#{third_value}"
        end

        def to_mathml_without_math_tag(_intent, **)
          XmlHelper.ox_element("mi")
        end

        def to_omml_without_math_tag(_, **)
          [XmlHelper.ox_element("m:r") << XmlHelper.ox_element("m:t")]
        end

        def to_html
          ""
        end

        def to_unicodemath(**)
          ""
        end
      end
    end
  end
end
