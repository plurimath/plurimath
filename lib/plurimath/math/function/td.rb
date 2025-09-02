# frozen_string_literal: true

require_relative "binary_function"
require_relative "../../mathml/utility"

module Plurimath
  module Math
    module Function
      class Td < BinaryFunction
        include Mathml::Utility

        def initialize(parameter_one = nil, parameter_two = nil)
          parameter_one&.delete_if { |td| td == "&" }
          super(Array(parameter_one), parameter_two)
        end

        def to_asciimath(options:)
          parameter_one.map do |val|
            val&.to_asciimath(options: td_asciimath_options(options, val))
          end.join(" ")
        end

        def to_mathml_without_math_tag(intent, options:)
          return "" if Utility.symbol_value(parameter_one.first, "|")

          td_attribute = parameter_two if parameter_two&.any?
          Utility.update_nodes(
            ox_element("mtd", attributes: td_attribute),
            parameter_one.map { |object| object&.to_mathml_without_math_tag(intent, options: options) },
          )
        end

        def to_latex(options:)
          return "" if Utility.symbol_value(parameter_one.first, "|")

          parameter_one.map { |val| val&.to_latex(options: options) }.join(" ")
        end

        def to_html(options:)
          first_value = parameter_one.map { |val| val.to_html(options: options) }.join
          "<td>#{first_value}</td>"
        end

        def to_omml_without_math_tag(display_style, options:)
          me = Utility.ox_element("e", namespace: "m")
          return [me] if parameter_one&.empty?

          Utility.update_nodes(me, omml_content(display_style, options: options))
          [me]
        end

        def to_unicodemath(options:)
          parameter_one&.map { |val| val&.to_unicodemath(options: options) }&.join
        end

        def to_asciimath_math_zone(spacing, last = false, _, options:)
          [
            "#{spacing}\"td\" function apply\n",
            Formula.new(parameter_one).to_asciimath_math_zone(gsub_spacing(spacing, last), last, options: options),
          ]
        end

        def to_latex_math_zone(spacing, last = false, indent = true, options:)
          [
            "#{spacing}\"td\" function apply\n",
            Formula.new(parameter_one).to_latex_math_zone(gsub_spacing(spacing, last), last, indent, options: options),
          ]
        end

        def to_mathml_math_zone(spacing, last = false, indent = true, options:)
          [
            "#{spacing}\"td\" function apply\n",
            Formula.new(parameter_one).to_mathml_math_zone(gsub_spacing(spacing, last), last, indent, options: options),
          ]
        end

        def to_omml_math_zone(spacing, last = false, indent = true, display_style:, options:)
          [
            "#{spacing}\"td\" function apply\n",
            Formula.new(parameter_one).to_omml_math_zone(gsub_spacing(spacing, last), last, indent, display_style: display_style, options: options),
          ]
        end

        def to_unicodemath_math_zone(spacing, last = false, _, options:)
          [
            "#{spacing}\"td\" function apply\n",
            Formula.new(parameter_one).to_unicodemath_math_zone(gsub_spacing(spacing, last), last, options: options),
          ]
        end

        def to_unicodemath_math_zone(spacing, last = false, _, options:)
          [
            "#{spacing}\"td\" function apply\n",
            Formula.new(parameter_one).to_unicodemath_math_zone(gsub_spacing(spacing, last), last, options: options),
          ]
        end

        def omml_content(display_style, options:)
          parameter_one&.map { |val| val.insert_t_tag(display_style, options: options) }
        end

        def line_breaking(obj)
          sliced_value = result(Array(parameter_one))
          return unless sliced_value.length > 1

          sliced_result = sliced_value.first.last.omml_line_break(sliced_value)
          table = Table.new(sliced_result.map { |res| Tr.new(Array(Td.new(Array(res)))) })
          self.parameter_one = [table]
        end

        private

        def td_asciimath_options(options, object)
          case object
          when ::Plurimath::Math::Symbols::Comma
            options.merge(literal_comma: true)
          when ::Plurimath::Math::Formula
            options.merge(table: true)
          else
            options
          end
        end
      end
    end
  end
end
