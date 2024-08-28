# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Right < UnaryFunction
        def to_asciimath(**)
          "right#{parameter_one}"
        end

        def to_mathml_without_math_tag(intent, **)
          mo = Utility.ox_element("mo")
          mo << right_paren if parameter_one
          mo
        end

        def to_omml_without_math_tag(_, **)
          mr = Utility.ox_element("m:r")
          if parameter_one
            mt = Utility.ox_element("m:t")
            mr << (mt << parameter_one)
          end
          [mr]
        end

        def to_html
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
          "#{spacing}\"#{latex_paren}\" right\n"
        end

        def to_latex_math_zone(spacing = "", _, _, **)
          "#{spacing}\"#{latex_paren}\" right\n"
        end

        def to_mathml_math_zone(spacing = "", _, _, **)
          mo_tag = (Utility.ox_element("mo") << right_paren)
          "#{spacing}\"#{dump_ox_nodes(mo_tag).gsub(/\s+/, "")}\" right\n"
        end

        def to_omml_math_zone(spacing = "", _, _, **)
          t_tag = (Utility.ox_element("t", namespace: "m") << right_paren)
          "#{spacing}\"#{dump_ox_nodes(t_tag).gsub(/\s+/, "")}\" right\n"
        end

        def to_unicodemath_math_zone(spacing = "", _, _, **)
          "#{spacing}\"#{parameter_one}\" right\n"
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
