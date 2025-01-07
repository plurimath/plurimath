# frozen_string_literal: true

require_relative "unary_function"
require_relative "../../mathml/utility"

module Plurimath
  module Math
    module Function
      class Msgroup < UnaryFunction
        include Mathml::Utility

        def to_asciimath(options:)
          parameter_one.map { |param| param.to_asciimath(options: options) }.join
        end

        def to_latex(options:)
          parameter_one.map { |param| param.to_latex(options: options) }.join
        end

        def to_mathml_without_math_tag(intent, options:)
          Utility.update_nodes(
            Utility.ox_element("msgroup"),
            parameter_one.map { |object| object&.to_mathml_without_math_tag(intent, options: options) },
          )
        end

        def to_omml_without_math_tag(display_style, options:)
          omml_value(display_style, options: options)
        end

        def to_html
          "<i>#{parameter_one.map(&:to_html).join}</i>"
        end

        def to_asciimath_math_zone(spacing, last = false, _indent = true, options:)
          [
            "#{spacing}\"msgroup\" function apply\n",
            Formula.new(parameter_one).to_asciimath_math_zone(gsub_spacing(spacing, last), options: options),
          ]
        end

        def to_latex_math_zone(spacing, last = false, indent = true, options:)
          [
            "#{spacing}\"msgroup\" function apply\n",
            Formula.new(parameter_one).to_latex_math_zone(gsub_spacing(spacing, last), last, indent, options: options),
          ]
        end

        def to_mathml_math_zone(spacing, last = false, indent = true, options:)
          [
            "#{spacing}\"msgroup\" function apply\n",
            Formula.new(parameter_one).to_mathml_math_zone(gsub_spacing(spacing, last), last, indent, options: options),
          ]
        end

        def to_omml_math_zone(spacing, last = false, indent = true, display_style:, options:)
          [
            "#{spacing}\"msgroup\" function apply\n",
            Formula.new(parameter_one).to_omml_math_zone(gsub_spacing(spacing, last), last, indent, display_style: display_style, options: options),
          ]
        end

        def to_unicodemath_math_zone(spacing, last = false, indent = true, options:)
          [
            "#{spacing}\"msgroup\" function apply\n",
            Formula.new(parameter_one).to_unicodemath_math_zone(gsub_spacing(spacing, last), last, indent, options: options),
          ]
        end

        def to_unicodemath(options:)
          parameter_one.map { |param| param.to_unicodemath(options: options) }.join
        end

        def line_breaking(obj)
          custom_array_line_breaking(obj)
        end

        def msgroup_text; end

        def msgroup_text=(value)
          return if empty_value?(value)

          if value.is_a?(Array)
            @temp_mathml_order << Text.new(value.pop)
          else
            @temp_mathml_order << Text.new(value)
          end
        end

        private

        def empty_value?(value)
          case value
          when String
            value.strip.empty?
          when Array
            value.none? { |element| element.match?(/[\S]/) }
          when NilClass
            true
          end
        end
      end
    end
  end
end
