# frozen_string_literal: true

require_relative "unary_function"
require_relative "../../mathml/utility"

module Plurimath
  module Math
    module Function
      class Ms < UnaryFunction
        include Mathml::Utility

        def to_mathml_without_math_tag(intent, **)
          Utility.ox_element("ms") << parameter_one
        end

        def to_asciimath(**)
          "\"“#{parameter_one}”\""
        end

        def to_latex(**)
          "\\text{“#{parameter_one}”}"
        end

        def to_omml_without_math_tag(display_style, **)
          [
            (Utility.ox_element("t", namespace: "m") << "“#{parameter_one}”"),
          ]
        end

        def to_unicodemath(options:)
          Text.new(parameter_one).to_unicodemath(options: options)
        end

        def value
          parameter_one
        end

        def value=(content)
          temp_content = updated_temp_mathml_values.flatten.map(&:to_ms_value)
          @parameter_one = [
            temp_content,
            content&.empty? ? nil : content,
          ].flatten.compact.join(" ")
        end

        def mi_value=(value)
          return if value.nil?

          @temp_mathml_order = replace_order_with_value(
            @temp_mathml_order,
            value,
            "mi"
          )
        end

        def mn_value=(value)
          return if value.nil?

          @temp_mathml_order = replace_order_with_value(
            @temp_mathml_order,
            value,
            "mn"
          )
        end

        def mo_value=(value)
          return if value.nil?

          @temp_mathml_order = replace_order_with_value(
            @temp_mathml_order,
            value,
            "mo"
          )
        end

        def msub_value=(value)
          return if value.nil?

          @temp_mathml_order = replace_order_with_value(
            @temp_mathml_order,
            value,
            "msub"
          )
        end

        def msup_value=(value)
          return if value.nil?

          @temp_mathml_order = replace_order_with_value(
            @temp_mathml_order,
            value,
            "msup"
          )
        end

        def msubsup_value=(value)
          return if value.nil?

          @temp_mathml_order = replace_order_with_value(
            @temp_mathml_order,
            value,
            "msubsup"
          )
        end

        def updated_temp_mathml_values
          @temp_mathml_order.map do |element|
            next element if element.is_a?(Math::Symbols::Symbol)

            update_temp_mathml_values([element])
          end
        end
      end
    end
  end
end
