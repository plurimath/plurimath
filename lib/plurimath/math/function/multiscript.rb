# frozen_string_literal: true

require_relative "ternary_function"
require_relative "../../mathml/utility"

module Plurimath
  module Math
    module Function
      class Multiscript < TernaryFunction
        include Mathml::Utility

        FUNCTION = {
          name: "multiscript",
          first_value: "base",
          second_value: "subscript",
          third_value: "supscript",
        }.freeze

        def to_asciimath(options:)
          subscript = "_(#{parameter_two&.map { |param| param.to_asciimath(options: options) }.join})" unless valid_value_exist?(parameter_two)
          supscript = "^(#{parameter_three&.map { |param| param.to_asciimath(options: options) }.join})" unless valid_value_exist?(parameter_three)
          prescript = "\\ #{subscript}#{supscript}" if subscript || supscript
          "#{prescript}#{parameter_one&.to_asciimath(options: options)}"
        end

        def to_latex(options:)
          subscript = "_{#{parameter_two&.map { |param| param.to_latex(options: options) }&.join}}" unless valid_value_exist?(parameter_two)
          supscript = "^{#{parameter_three&.map { |param| param.to_latex(options: options) }&.join}}" unless valid_value_exist?(parameter_three)
          prescript = "{}#{subscript}#{supscript}" if subscript || supscript
          "#{prescript}#{parameter_one&.to_latex(options: options)}"
        end

        def to_mathml_without_math_tag(intent, options:)
          mprescript = ox_element("mprescripts") if parameter_two || parameter_three
          Utility.update_nodes(
            ox_element("mmultiscripts"),
            [
              parameter_one&.mmultiscript(intent, options: options),
              mprescript,
              validate_mathml_fields(prescripts, intent, options: options),
            ]
          )
        end

        def to_omml_without_math_tag(display_style, options:)
          Utility.update_nodes(
            ox_element("sPre", namespace: "m"),
            [
              omml_parameter(parameter_one, display_style, tag_name: "e", options: options),
              omml_parameter(parameter_two, display_style, tag_name: "sub", options: options),
              omml_parameter(parameter_three, display_style, tag_name: "sup", options: options),
            ],
          )
        end

        def to_unicodemath(options:)
          first_value = sub_value(options: options) if unicode_valid_value?(parameter_two)
          second_value = sup_value(options: options) if unicode_valid_value?(parameter_three)
          "#{first_value}#{second_value} #{parameter_one&.to_unicodemath(options: options)}"
        end

        def line_breaking(obj)
          parameter_one&.line_breaking(obj)
          if obj.value_exist?
            obj.update(
              self.class.new(Utility.filter_values(obj.value), parameter_two, parameter_three)
            )
            self.parameter_two = nil
            self.parameter_three = nil
            return
          end

          array_line_break_field(
            parameter_two,
            :@parameter_two,
            obj,
          )
          if obj.value_exist?
            obj.update(
              self.class.new(nil, obj.value, parameter_three)
            )
            self.parameter_three = nil
          end
        end

        def none_value=(value)
          return if value.nil? || value.empty?

          @temp_mathml_order = replace_order_with_value(
            @temp_mathml_order,
            value,
            "none"
          )
        end

        private

        def prescripts
          return parameter_three if parameter_two&.nil? || parameter_two&.empty?
          return parameter_two if parameter_three.nil? || parameter_three.empty?

          prescripts_array = []
          Array(parameter_two).zip(Array(parameter_three)) { |array| prescripts_array << array }
          prescripts_array.flatten.compact
        end

        def valid_value_exist?(field)
          !field && (field&.empty? || field&.all?(None))
        end

        def unicode_valid_value?(field)
          !field.empty? && !valid_value_exist?(field)
        end

        def sup_value(options:)
          field = Utility.filter_values(parameter_two)
          field_value = parameter_three.map { |param| param.to_unicodemath(options: options) }.join
          if field&.mini_sized? || prime_unicode?(field)
            field_value
          elsif field.is_a?(Math::Function::Power)
            "^#{field_value}"
          elsif parameter_three && !parameter_three.empty?
            "^(#{field_value})"
          end
        end

        def sub_value(options:)
          field = Utility.filter_values(parameter_two)
          field_value = parameter_two&.map { |param| param.to_unicodemath(options: options) }.join
          if field&.mini_sized?
            field_value
          elsif parameter_two.is_a?(Math::Function::Base)
            "_#{field_value}"
          elsif parameter_two && !parameter_two.empty?
            "_(#{field_value})"
          end
        end
      end
    end
  end
end
