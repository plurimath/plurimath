# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Tr < UnaryFunction
        def initialize(parameter_one = [])
          parameter_one.map!.with_index { |_, index| Td.new([]) } if parameter_one&.all?("@")
          super(parameter_one)
        end

        def to_asciimath
          "[#{parameter_one.map(&:to_asciimath).join(', ')}]"
        end

        def to_mathml_without_math_tag(intent)
          first_value = remove_hline(cloned_objects.parameter_one)
          Utility.update_nodes(
            Utility.ox_element("mtr"),
            first_value.map { |obj| obj&.to_mathml_without_math_tag(intent) }.compact,
          )
        end

        def to_latex
          parameter_one.reject do |td|
            td if Utility.symbol_value(td, "|") || Utility.symbol_value(td.parameter_one.first, "|")
          end.map(&:to_latex).join(" & ")
        end

        def to_html
          first_value = parameter_one.map(&:to_html).join
          "<tr>#{first_value}</tr>"
        end

        def to_omml_without_math_tag(display_style)
          omml_content = parameter_one&.map { |object| object.to_omml_without_math_tag(display_style) }
          if parameter_one.count.eql?(1)
            omml_content
          else
            mr = Utility.ox_element("mr", namespace: "m")
            Utility.update_nodes(
              mr,
              omml_content,
            )
            [mr]
          end
        end

        def to_unicodemath
          parameter_one&.map(&:to_unicodemath)&.join("&")
        end

        def to_asciimath_math_zone(spacing, last = false, indent = true)
          [
            "#{spacing}\"tr\" function apply\n",
            Formula.new(parameter_one).to_asciimath_math_zone(gsub_spacing(spacing, last), last, indent),
          ]
        end

        def to_latex_math_zone(spacing, last = false, indent = true)
          [
            "#{spacing}\"tr\" function apply\n",
            Formula.new(parameter_one).to_latex_math_zone(gsub_spacing(spacing, last), last, indent),
          ]
        end

        def to_mathml_math_zone(spacing, last = false, indent = true)
          [
            "#{spacing}\"tr\" function apply\n",
            Formula.new(parameter_one).to_mathml_math_zone(gsub_spacing(spacing, last), last, indent),
          ]
        end

        def to_omml_math_zone(spacing, last = false, indent = true, display_style:)
          [
            "#{spacing}\"tr\" function apply\n",
            Formula.new(parameter_one).to_omml_math_zone(gsub_spacing(spacing, last), last, indent, display_style: display_style),
          ]
        end

        def to_unicodemath_math_zone(spacing, last = false, indent = true)
          [
            "#{spacing}\"tr\" function apply\n",
            Formula.new(parameter_one).to_unicodemath_math_zone(gsub_spacing(spacing, last), last, indent),
          ]
        end

        def remove_hline(first_value)
          row_lines = first_value.first.parameter_one
          row_lines.shift if row_lines.first.is_a?(Math::Symbols::Hline)
          first_value
        end
      end
    end
  end
end
