# frozen_string_literal: true

require_relative "ternary_function"
module Plurimath
  module Math
    module Function
      class Multiscript < TernaryFunction
        FUNCTION = {
          name: "multiscript",
          first_value: "base",
          second_value: "subscript",
          third_value: "supscript",
        }.freeze

        def to_asciimath
          subscript = "_(#{parameter_two&.map(&:to_asciimath).join})" unless valid_value_exist?(parameter_two)
          supscript = "^(#{parameter_three&.map(&:to_asciimath).join})" unless valid_value_exist?(parameter_three)
          prescript = "\\ #{subscript}#{supscript}" if subscript || supscript
          "#{prescript}#{parameter_one&.to_asciimath}"
        end

        def to_latex
          subscript = "_{#{parameter_two&.map(&:to_latex).join}}" unless valid_value_exist?(parameter_two)
          supscript = "^{#{parameter_three&.map(&:to_latex).join}}" unless valid_value_exist?(parameter_three)
          prescript = "{}#{subscript}#{supscript}" if subscript || supscript
          "#{prescript}#{parameter_one&.to_latex}"
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

        def to_omml_without_math_tag(display_style)
          Utility.update_nodes(
            ox_element("sPre", namespace: "m"),
            [
              omml_parameter(parameter_one, display_style, tag_name: "e"),
              omml_parameter(parameter_two, display_style, tag_name: "sub"),
              omml_parameter(parameter_three, display_style, tag_name: "sup"),
            ],
          )
        end

        def to_unicodemath
          first_value = sub_value if unicode_valid_value?(parameter_two)
          second_value = sup_value if unicode_valid_value?(parameter_three)
          "#{first_value}#{second_value} #{parameter_one&.to_unicodemath}"
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

        def sup_value
          field = Utility.filter_values(parameter_two)
          if field&.mini_sized? || prime_unicode?(field)
            parameter_three.map(&:to_unicodemath).join
          elsif field.is_a?(Math::Function::Power)
            "^#{parameter_three.map(&:to_unicodemath).join}"
          elsif parameter_three && !parameter_three.empty?
            "^(#{parameter_three.map(&:to_unicodemath).join})"
          end
        end

        def sub_value
          field = Utility.filter_values(parameter_two)
          if field&.mini_sized?
            parameter_two.map(&:to_unicodemath).join
          elsif parameter_two.is_a?(Math::Function::Base)
            "_#{parameter_two.map(&:to_unicodemath).join}"
          elsif parameter_two && !parameter_two.empty?
            "_(#{parameter_two.map(&:to_unicodemath).join})"
          end
        end
      end
    end
  end
end
