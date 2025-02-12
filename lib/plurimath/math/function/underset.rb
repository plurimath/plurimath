# frozen_string_literal: true

require_relative "binary_function"
require_relative "../../mathml/utility"

module Plurimath
  module Math
    module Function
      class Underset < BinaryFunction
        include Mathml::Utility

        attr_accessor :options

        FUNCTION = {
          name: "underscript",
          first_value: "underscript value",
          second_value: "base expression",
        }.freeze

        def initialize(
          parameter_one = nil,
          parameter_two = nil,
          options = {})
          super(parameter_one, parameter_two)
          @options = options unless options.empty?
        end

        def element_order=(value)
          @temp_mathml_order = validated_order(
            value&.map(&:name),
            rejectable_array: ["comment"]
          )
        end

        def to_mathml_without_math_tag(intent, options:)
          value_array = [
            validate_mathml_fields(parameter_two, intent, options: options),
            validate_mathml_fields(parameter_one, intent, options: options),
          ]
          Utility.update_nodes(ox_element("munder", attributes: self.options), value_array)
        end

        def to_omml_without_math_tag(display_style, options:)
          if !display_style
            base = Base.new(parameter_one, parameter_two)
            return base.to_omml_without_math_tag(display_style, options: options)
          end

          limlow   = Utility.ox_element("limLow", namespace: "m")
          limlowpr = Utility.ox_element("limLowPr", namespace: "m")
          limlowpr << Utility.pr_element("ctrl", true, namespace: "m")
          Utility.update_nodes(
            limlow,
            [
              limlowpr,
              omml_parameter(parameter_one, display_style, tag_name: "e", options: options),
              omml_parameter(parameter_two, display_style, tag_name: "lim", options: options),
            ],
          )
          [limlow]
        end

        def to_unicodemath(options:)
          return "#{parameter_one.to_unicodemath(options: options)}#{unicodemath_parens(parameter_two, options: options)}" if horizontal_brackets?
          return "#{parameter_two.to_unicodemath(options: options)}_#{unicodemath_parens(parameter_one, options: options)}" if unicode_classes_accent?(parameter_two)
          return "#{unicodemath_parens(parameter_two, options: options)}#{unicodemath_field_value(parameter_one)}" if unicode_accent?(parameter_one)

          "#{unicodemath_parens(parameter_two, options: options)}┬#{parameter_one.to_unicodemath(options: options)}"
        end

        def line_breaking(obj)
          parameter_one&.line_breaking(obj)
          if obj.value_exist?
            obj.update(self.class.new(Utility.filter_values(obj.value), parameter_two))
            self.parameter_two = nil
            return
          end

          parameter_two&.line_breaking(obj)
          if obj.value_exist?
            obj.update(self.class.new(nil, Utility.filter_values(obj.value)))
          end
        end

        def new_nary_function(fourth_value)
          Nary.new(parameter_two, parameter_one, nil, fourth_value, { type: "undOvr" })
        end

        def is_nary_function?
          parameter_two.is_nary_function? || parameter_two.is_nary_symbol?
        end

        def content=(value)
          if no_content_in?(Array(value))
            delete_all_text
          else
            new_val = Array(value).map do |val|
              validate_symbols(val) unless val.strip.empty?
            end
            validate_text_order(new_val)
          end
          update_temp_mathml_values(@temp_mathml_order)
        end

        protected

        def validate_text_order(value)
          @temp_mathml_order.each_with_index do |item, index|
            next unless item == "text"

            shifted_value = value.shift
            next @temp_mathml_order[index] = shifted_value if shifted_value

            @temp_mathml_order.delete_at(index)
          end
        end

        def delete_all_text
          @temp_mathml_order.delete("text")
        end

        def no_content_in?(value)
          value.nil? ||
            value.empty? ||
            value&.all? { |val| val.strip.empty? }
        end

        def unicode_accent?(field)
          return unless field.is_a?(Math::Symbols::Symbol)

          match_unicode?(unicodemath_field_value(field))
        end

        def horizontal_brackets?
          return unless parameter_one.is_a?(Math::Symbols::Symbol)

          UnicodeMath::Constants::HORIZONTAL_BRACKETS.value?(unicodemath_field_value(parameter_one))
        end

        def unicode_classes_accent?(field)
          (field.is_a?(Math::Function::Obrace) || field.is_a?(Math::Function::Ubrace))
        end

        def match_unicode?(unicode)
          UnicodeMath::Constants::DIACRITIC_BELOWS.include?(unicode) ||
            UnicodeMath::Constants::ACCENT_SYMBOLS.has_value?(unicode)
        end
      end
    end
  end
end
