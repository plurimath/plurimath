# frozen_string_literal: true

require_relative "unary_function"
require_relative "../../mathml/utility"

module Plurimath
  module Math
    module Function
      class Tr < UnaryFunction
        include Mathml::Utility

        def initialize(parameter_one = [])
          parameter_one.map!.with_index { |_, index| Td.new([]) } if parameter_one&.all?("@")
          super(parameter_one)
        end

        def to_asciimath(options:)
          tr_value = parameter_one.map { |param| param.to_asciimath(options: options) }.join(', ')
          "[#{tr_value}]"
        end

        def to_mathml_without_math_tag(intent, options:)
          first_value = remove_hline(cloned_objects.parameter_one)
          Utility.update_nodes(
            Utility.ox_element("mtr"),
            first_value.map { |obj| obj&.to_mathml_without_math_tag(intent, options: options) }.compact,
          )
        end

        def to_latex(options:)
          parameter_one.reject do |td|
            td if Utility.symbol_value(td, "|") || Utility.symbol_value(td.parameter_one.first, "|")
          end.map { |td| td.to_latex(options: options) }.join(" & ")
        end

        def to_html(options:)
          first_value = parameter_one.map { |val| val.to_html(options: options) }.join
          "<tr>#{first_value}</tr>"
        end

        def to_omml_without_math_tag(display_style, options:)
          omml_content = parameter_one&.map { |object| object.to_omml_without_math_tag(display_style, options: options) }
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

        def to_unicodemath(options:)
          parameter_one&.map { |param| param.to_unicodemath(options: options) }&.join("&")
        end

        def to_asciimath_math_zone(spacing, last = false, indent = true, options:)
          [
            "#{spacing}\"tr\" function apply\n",
            Formula.new(parameter_one).to_asciimath_math_zone(gsub_spacing(spacing, last), last, indent, options: options),
          ]
        end

        def to_latex_math_zone(spacing, last = false, indent = true, options:)
          [
            "#{spacing}\"tr\" function apply\n",
            Formula.new(parameter_one).to_latex_math_zone(gsub_spacing(spacing, last), last, indent, options: options),
          ]
        end

        def to_mathml_math_zone(spacing, last = false, indent = true, options:)
          [
            "#{spacing}\"tr\" function apply\n",
            Formula.new(parameter_one).to_mathml_math_zone(gsub_spacing(spacing, last), last, indent, options: options),
          ]
        end

        def to_omml_math_zone(spacing, last = false, indent = true, display_style:, options:)
          [
            "#{spacing}\"tr\" function apply\n",
            Formula.new(parameter_one).to_omml_math_zone(gsub_spacing(spacing, last), last, indent, display_style: display_style, options: options),
          ]
        end

        def to_unicodemath_math_zone(spacing, last = false, indent = true, options:)
          [
            "#{spacing}\"tr\" function apply\n",
            Formula.new(parameter_one).to_unicodemath_math_zone(gsub_spacing(spacing, last), last, indent, options: options),
          ]
        end

        def remove_hline(first_value)
          row_lines = first_value.first.parameter_one
          row_lines.shift if row_lines.first.is_a?(Math::Symbols::Hline)
          first_value
        end

        def mtd_value=(value)
          return if value.nil? || value.empty?

          self.parameter_one = replace_order_with_value(
            clear_temp_order,
            update_temp_mathml_values(value),
            "mtd"
          )
        end
      end
    end
  end
end
