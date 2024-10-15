# frozen_string_literal: true

require_relative "binary_function"
require_relative "../../mathml/utility"

module Plurimath
  module Math
    module Function
      class Power < BinaryFunction
        include Mathml::Utility

        attr_accessor :temp_mathml_order

        FUNCTION = {
          name: "superscript",
          first_value: "base",
          second_value: "script",
        }.freeze

        def element_order=(order)
          self.temp_mathml_order = validated_order(order)
        end

        def to_asciimath(options:)
          second_value = "^#{wrapped(parameter_two, options: options)}" if parameter_two
          "#{parameter_one.to_asciimath(options: options)}#{second_value}"
        end

        def to_mathml_without_math_tag(intent, options:)
          tag_name = ["ubrace", "obrace"].include?(parameter_one&.class_name) ? "over" : "sup"
          value_array = [
            validate_mathml_fields(parameter_one, intent, options: options),
            validate_mathml_fields(parameter_two, intent, options: options),
          ]
          Utility.update_nodes(ox_element("m#{tag_name}"), value_array)
        end

        def to_latex(options:)
          first_value  = parameter_one.to_latex(options: options)
          second_value = parameter_two.to_latex(options: options) if parameter_two
          "#{first_value}^{#{second_value}}"
        end

        def to_html(options:)
          first_value  = "<i>#{parameter_one.to_html(options: options)}</i>" if parameter_one
          second_value = "<sup>#{parameter_two.to_html(options: options)}</sup>" if parameter_two
          "#{first_value}#{second_value}"
        end

        def to_omml_without_math_tag(display_style, options:)
          ssup_element  = Utility.ox_element("sSup", namespace: "m")
          suppr_element = Utility.ox_element("sSupPr", namespace: "m")
          suppr_element << Utility.pr_element("ctrl", true, namespace: "m")
          Utility.update_nodes(
            ssup_element,
            [
              suppr_element,
              omml_parameter(parameter_one, display_style, tag_name: "e", options: options),
              omml_parameter(parameter_two, display_style, tag_name: "sup", options: options),
            ],
          )
          [ssup_element]
        end

        def to_unicodemath(options:)
          if accented?(parameter_two)
            "#{parameter_one.to_unicodemath(options: options)}#{parameter_two.to_unicodemath(options: options).gsub(/\s+/, "")}"
          elsif parameter_two.mini_sized?
            "#{parameter_one.to_unicodemath(options: options)}#{parameter_two.to_unicodemath(options: options)}"
          else
            first_value = parameter_one.to_unicodemath(options: options) if parameter_one
            second_value = if parameter_two.is_a?(self.class)
              "^#{parameter_two.to_unicodemath(options: options)}"
            else
              "^#{unicodemath_parens(parameter_two, options: options)}"
            end
            "#{first_value}#{second_value}"
          end
        end

        def line_breaking(obj)
          parameter_one&.line_breaking(obj)
          if obj.value_exist?
            obj.update(self.class.new(Utility.filter_values(obj.value), parameter_two))
            self.parameter_two = nil
          end
        end

        def new_nary_function(fourth_value)
          Nary.new(parameter_one, nil, parameter_two, fourth_value)
        end

        def is_nary_function?
          parameter_one.is_nary_function? || parameter_one.is_nary_symbol?
        end

        def mi_value=(value)
          return if value.nil? || value.empty?

          self.temp_mathml_order = replace_order_with_value(
            self.temp_mathml_order,
            validate_symbols(value),
            "mi"
          )
        end

        def mo_value=(value)
          return if value.nil? || value.empty?

          self.temp_mathml_order = replace_order_with_value(
            self.temp_mathml_order,
            validate_symbols(value),
            "mo"
          )
        end

        def mn_value=(value)
          return if value.nil? || value.empty?

          self.temp_mathml_order = replace_order_with_value(
            self.temp_mathml_order,
            validate_symbols(value),
            "mn"
          )
        end

        def ms_value=(value)
          return if value.nil? || value.empty?

          self.temp_mathml_order = replace_order_with_value(
            self.temp_mathml_order,
            Array(filter_values(value)),
            "ms"
          )
        end

        def mtext_value=(value)
          return if value.nil? || value.empty?

          self.temp_mathml_order = replace_order_with_value(
            self.temp_mathml_order,
            Array(filter_values(value)),
            "mtext"
          )
        end

        def mrow_value=(value)
          return if value.nil? || value.empty?

          self.temp_mathml_order = replace_order_with_value(
            self.temp_mathml_order,
            Array(filter_values(value)),
            "mrow"
          )
        end

        def mstyle_value=(value)
          return if value.nil? || value.empty?

          self.temp_mathml_order = replace_order_with_value(
            self.temp_mathml_order,
            Array(filter_values(value)),
            "mstyle"
          )
        end

        def munderover_value=(value)
          return if value.nil? || value.empty?

          self.temp_mathml_order = replace_order_with_value(
            self.temp_mathml_order,
            Array(update_underover(value)),
            "munderover"
          )
        end

        def munder_value=(value)
          return if value.nil? || value.empty?

          self.temp_mathml_order = replace_order_with_value(
            self.temp_mathml_order,
            Array(update_underover(value)),
            "munder"
          )
        end

        def mover_value=(value)
          return if value.nil? || value.empty?

          self.temp_mathml_order = replace_order_with_value(
            self.temp_mathml_order,
            Array(update_underover(value)),
            "mover"
          )
        end

        def msubsup_value=(value)
          return if value.nil? || value.empty?

          self.temp_mathml_order = replace_order_with_value(
            self.temp_mathml_order,
            Array(update_underover(value)),
            "msubsup"
          )
        end

        def msub_value=(value)
          return if value.nil? || value.empty?

          self.temp_mathml_order = replace_order_with_value(
            self.temp_mathml_order,
            Array(update_underover(value)),
            "msub"
          )
        end

        def msup_value=(value)
          return if value.nil? || value.empty?

          self.temp_mathml_order = replace_order_with_value(
            self.temp_mathml_order,
            Array(update_underover(value)),
            "msup"
          )
        end

        protected

        def accented?(field)
          (field.is_a?(Math::Symbols::Symbol) && prime_unicode?(field)) ||
            (field.is_a?(Math::Formula) && prime_unicode?(field.value.first)) ||
            (field.is_a?(Math::Function::Power) && prime_unicode?(field.parameter_one))
        end
      end
    end
  end
end
