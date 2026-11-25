# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Right < UnaryFunction
        autoload :DisplayTreeMethods, "plurimath/math/function/right/display_tree_methods"

        def to_asciimath(**)
          "right#{parameter_one}"
        end

        def to_mathml_without_math_tag(_intent, **)
          mo = XmlHelper.ox_element("mo")
          mo << right_paren if parameter_one
          mo
        end

        def to_omml_without_math_tag(_, **)
          mr = XmlHelper.ox_element("m:r")
          if parameter_one
            mt = XmlHelper.ox_element("m:t")
            mr << (mt << parameter_one)
          end
          [mr]
        end

        def to_html(**)
          "<i>#{parameter_one}</i>"
        end

        def to_latex(**)
          "\\right #{latex_paren}"
        end

        def to_unicodemath(**)
          parameter_one
        end

        def validate_function_formula
          false
        end

        def to_asciimath_math_zone(spacing = "", _, _, **)
          Right.include(DisplayTreeMethods) unless Right < DisplayTreeMethods
          super
        end

        def to_latex_math_zone(spacing = "", _, _, **)
          Right.include(DisplayTreeMethods) unless Right < DisplayTreeMethods
          super
        end

        def to_mathml_math_zone(spacing = "", _, _, **)
          Right.include(DisplayTreeMethods) unless Right < DisplayTreeMethods
          super
        end

        def to_omml_math_zone(spacing = "", _, _, **)
          Right.include(DisplayTreeMethods) unless Right < DisplayTreeMethods
          super
        end

        def to_unicodemath_math_zone(spacing = "", _, _, **)
          Right.include(DisplayTreeMethods) unless Right < DisplayTreeMethods
          super
        end

        protected

        def right_paren
          return "}" if parameter_one == "\\}"

          parameter_one
        end
      end
    end
  end
end
