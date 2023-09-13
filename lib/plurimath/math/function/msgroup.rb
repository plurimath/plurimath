# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Msgroup < UnaryFunction
        def to_asciimath
          parameter_one.map(&:to_asciimath).join
        end

        def to_latex
          parameter_one.map(&:to_latex).join
        end

        def to_mathml_without_math_tag
          Utility.update_nodes(
            Utility.ox_element("msgroup"),
            parameter_one.map(&:to_mathml_without_math_tag),
          )
        end

        def to_omml_without_math_tag(display_style)
          omml_value(display_style)
        end

        def to_html
          "<i>#{parameter_one.map(&:to_html).join}</i>"
        end

        def to_asciimath_math_zone(spacing, last = false, _indent = true)
          [
            "#{spacing}\"msgroup\" function apply\n",
            Formula.new(parameter_one).to_asciimath_math_zone(gsub_spacing(spacing, last)),
          ]
        end

        def to_latex_math_zone(spacing, last = false, indent = true)
          [
            "#{spacing}\"msgroup\" function apply\n",
            Formula.new(parameter_one).to_latex_math_zone(gsub_spacing(spacing, last), last, indent),
          ]
        end

        def to_mathml_math_zone(spacing, last = false, indent = true)
          [
            "#{spacing}\"msgroup\" function apply\n",
            Formula.new(parameter_one).to_mathml_math_zone(gsub_spacing(spacing, last), last, indent),
          ]
        end

        def to_omml_math_zone(spacing, last = false, indent = true, display_style:)
          [
            "#{spacing}\"msgroup\" function apply\n",
            Formula.new(parameter_one).to_omml_math_zone(gsub_spacing(spacing, last), last, indent, display_style: display_style),
          ]
        end
      end
    end
  end
end
