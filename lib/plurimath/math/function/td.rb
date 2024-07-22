# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Td < BinaryFunction
        def initialize(parameter_one = nil, parameter_two = nil)
          parameter_one&.delete_if { |td| td == "&" }
          super(parameter_one, parameter_two)
        end

        def to_asciimath
          parameter_one.map(&:to_asciimath).join(" ")
        end

        def to_mathml_without_math_tag(intent)
          return "" if Utility.symbol_value(parameter_one.first, "|")

          td_attribute = parameter_two if parameter_two&.any?
          Utility.update_nodes(
            ox_element("mtd", attributes: td_attribute),
            parameter_one.map { |object| object&.to_mathml_without_math_tag(intent) },
          )
        end

        def to_latex
          return "" if Utility.symbol_value(parameter_one.first, "|")

          parameter_one.map(&:to_latex).join(" ")
        end

        def to_html
          first_value = parameter_one.map(&:to_html).join
          "<td>#{first_value}</td>"
        end

        def to_omml_without_math_tag(display_style)
          me = Utility.ox_element("e", namespace: "m")
          return [me] if parameter_one&.empty?

          Utility.update_nodes(me, omml_content(display_style))
          [me]
        end

        def to_unicodemath
          parameter_one&.map(&:to_unicodemath)&.join
        end

        def to_asciimath_math_zone(spacing, last = false, _)
          [
            "#{spacing}\"td\" function apply\n",
            Formula.new(parameter_one).to_asciimath_math_zone(gsub_spacing(spacing, last), last),
          ]
        end

        def to_latex_math_zone(spacing, last = false, indent = true)
          [
            "#{spacing}\"td\" function apply\n",
            Formula.new(parameter_one).to_latex_math_zone(gsub_spacing(spacing, last), last, indent),
          ]
        end

        def to_mathml_math_zone(spacing, last = false, indent = true)
          [
            "#{spacing}\"td\" function apply\n",
            Formula.new(parameter_one).to_mathml_math_zone(gsub_spacing(spacing, last), last, indent),
          ]
        end

        def to_omml_math_zone(spacing, last = false, indent = true, display_style:)
          [
            "#{spacing}\"td\" function apply\n",
            Formula.new(parameter_one).to_omml_math_zone(gsub_spacing(spacing, last), last, indent, display_style: display_style),
          ]
        end

        def to_unicodemath_math_zone(spacing, last = false, _)
          [
            "#{spacing}\"td\" function apply\n",
            Formula.new(parameter_one).to_unicodemath_math_zone(gsub_spacing(spacing, last), last),
          ]
        end

        def to_unicodemath_math_zone(spacing, last = false, _)
          [
            "#{spacing}\"td\" function apply\n",
            Formula.new(parameter_one).to_unicodemath_math_zone(gsub_spacing(spacing, last), last),
          ]
        end
        
        def omml_content(display_style)
          parameter_one&.map { |val| val.insert_t_tag(display_style) }
        end

        def line_breaking(obj)
          sliced_value = result(Array(parameter_one))
          return unless sliced_value.length > 1

          sliced_result = sliced_value.first.last.omml_line_break(sliced_value)
          table = Table.new(sliced_result.map { |res| Tr.new(Array(Td.new(Array(res)))) })
          self.parameter_one = [table]
        end
      end
    end
  end
end
