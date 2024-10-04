# frozen_string_literal: true

require_relative "binary_function"
require_relative "../../mathml/utility"

module Plurimath
  module Math
    module Function
      class Overset < BinaryFunction
        include Mathml::Utility

        attr_accessor :options

        FUNCTION = {
          name: "overset",
          first_value: "base",
          second_value: "supscript",
        }.freeze

        def initialize(
          parameter_one = nil,
          parameter_two = nil,
          options = {})
          super(parameter_one, parameter_two)
          @options = options unless options.empty?
        end

        def to_mathml_without_math_tag(intent, options:)
          value_array = [
            validate_mathml_fields(parameter_two, intent, options: options),
            validate_mathml_fields(parameter_one, intent, options: options),
          ]
          Utility.update_nodes(
            ox_element("mover", attributes: self.options),
            value_array,
          )
        end

        def to_omml_without_math_tag(display_style, options:)
          if !display_style
            power = Power.new(parameter_one, parameter_two)
            return power.to_omml_without_math_tag(display_style, options: options)
          end

          limupp   = Utility.ox_element("limUpp", namespace: "m")
          limupppr = Utility.ox_element("limUppPr", namespace: "m")
          limupppr << Utility.pr_element("ctrl", true, namespace: "m")
          Utility.update_nodes(
            limupp,
            [
              limupppr,
              omml_parameter(parameter_one, display_style, tag_name: "e", options: options),
              omml_parameter(parameter_two, display_style, tag_name: "lim", options: options),
            ],
          )
          [limupp]
        end

        def to_unicodemath(options:)
          return "#{unicodemath_parens(parameter_two, options: options)}#{unicodemath_field_value(parameter_one)}" if unicode_accent?(parameter_one)
          return "#{unicodemath_field_value(parameter_one)}#{parameter_two.to_unicodemath(options: options)}" if unicode_accent?(parameter_two)
          return "#{parameter_one.to_unicodemath(options: options)}#{unicodemath_parens(parameter_two, options: options)}" if horizontal_brackets?
          return "#{parameter_two.to_unicodemath(options: options)}^#{unicodemath_parens(parameter_one, options: options)}" if unicode_classes_accent?(parameter_two)

          "#{unicodemath_parens(parameter_two, options: options)}┴#{unicodemath_parens(parameter_one, options: options)}" if parameter_one || parameter_two
        end

        def line_breaking(obj)
          parameter_two&.line_breaking(obj)
          if obj.value_exist?
            obj.update(self.class.new(parameter_one, Utility.filter_values(obj.value)))
            self.parameter_one = nil
          end
        end

        def new_nary_function(fourth_value)
          Nary.new(parameter_two, nil, parameter_one, fourth_value, { type: "undOvr" })
        end

        def is_nary_function?
          parameter_two.is_nary_function? || parameter_two.is_nary_symbol?
        end

        def accent=(value)
          return unless value

          @options ||= {}
          @options[:accent] = value
        end

        protected

        def unicode_accent?(field)
          return unless field.is_a?(Math::Symbols::Symbol)

          match_unicode?(unicodemath_field_value(field))
        end

        def unicode_classes_accent?(field)
          field.is_a?(Math::Function::Obrace) ||
            field.is_a?(Math::Function::Ubrace)
        end

        def horizontal_brackets?
          return unless parameter_one.is_a?(Math::Symbols::Symbol)

          UnicodeMath::Constants::HORIZONTAL_BRACKETS.value?(unicodemath_field_value(parameter_one))
        end

        def match_unicode?(unicode)
          UnicodeMath::Constants::DIACRITIC_OVERLAYS.include?(unicode) ||
            UnicodeMath::Constants::ACCENT_SYMBOLS.has_value?(unicode)
        end
      end
    end
  end
end
