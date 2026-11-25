# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Left < UnaryFunction
        autoload :DisplayTreeMethods, "plurimath/math/function/left/display_tree_methods"

        def to_asciimath(**)
          "left#{parameter_one}"
        end

        def to_mathml_without_math_tag(_intent, **)
          mo = XmlHelper.ox_element("mo")
          mo << left_paren if parameter_one
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
          "\\left #{latex_paren}"
        end

        def to_unicodemath(**)
          parameter_one
        end

        def validate_function_formula
          false
        end

        def to_asciimath_math_zone(spacing = "", _, _, **)
          Left.include(DisplayTreeMethods) unless Left < DisplayTreeMethods
          super
        end

        def to_latex_math_zone(spacing = "", _, _, **)
          Left.include(DisplayTreeMethods) unless Left < DisplayTreeMethods
          super
        end

        def to_mathml_math_zone(spacing = "", _, _, **)
          Left.include(DisplayTreeMethods) unless Left < DisplayTreeMethods
          super
        end

        def to_omml_math_zone(spacing = "", _, _, display_style:, **)
          Left.include(DisplayTreeMethods) unless Left < DisplayTreeMethods
          super
        end

        def to_unicodemath_math_zone(spacing = "", _, _, **)
          Left.include(DisplayTreeMethods) unless Left < DisplayTreeMethods
          super
        end

        protected

        def left_paren
          return "{" if parameter_one == "\\{"

          parameter_one
        end
      end
    end
  end
end
