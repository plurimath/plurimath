# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Inf < BinaryFunction
        def to_asciimath(options:)
          first_value = "_(#{parameter_one.to_asciimath(options: options)})" if parameter_one
          second_value = "^(#{parameter_two.to_asciimath(options: options)})" if parameter_two
          "#{class_name}#{first_value}#{second_value}"
        end

        def to_latex(options:)
          first_value = "_{#{parameter_one.to_latex(options: options)}}" if parameter_one
          second_value = "^{#{parameter_two.to_latex(options: options)}}" if parameter_two
          "\\#{class_name}#{first_value}#{second_value}"
        end

        def to_mathml_without_math_tag(intent, options:)
          first_value = Utility.ox_element("mo") << class_name
          return first_value unless all_values_exist?

          tag_name = if parameter_two && parameter_one
                       "underover"
                     else
                       parameter_one ? "under" : "over"
                     end
          inf_tag = ox_element("m#{tag_name}")
          Utility.update_nodes(
            inf_tag,
            [
              first_value,
              parameter_one&.to_mathml_without_math_tag(intent, options: options),
              parameter_two&.to_mathml_without_math_tag(intent, options: options),
            ],
          )
          intentify(inf_tag, intent, func_name: :function, intent_name: intent_names[:name])
        end

        def to_omml_without_math_tag(display_style, options:)
          underover(display_style, options: options)
        end

        def line_breaking(obj)
          parameter_one.line_breaking(obj)
          if obj.value_exist?
            obj.update(
              Underover.new(nil, Utility.filter_values(obj.value), parameter_two)
            )
            self.parameter_two = nil
          end
        end

        def to_unicodemath(options:)
          "inf#{sub_value(options: options)}#{sup_value(options: options)}"
        end

        def intent_names
          { name: ":function" }
        end

        protected

        def sup_value(options:)
          return unless parameter_two

          if parameter_two&.mini_sized? || prime_unicode?(parameter_two)
            parameter_two.to_unicodemath(options: options)
          elsif parameter_two.is_a?(Math::Function::Power)
            "^#{parameter_two.to_unicodemath(options: options)}"
          else
            "^#{unicodemath_parens(parameter_two, options: options)}"
          end
        end

        def sub_value(options:)
          return unless parameter_one

          if parameter_one&.mini_sized?
            parameter_one.to_unicodemath(options: options)
          elsif parameter_one.is_a?(Math::Function::Base)
            "_#{parameter_one.to_unicodemath(options: options)}"
          else
            "_#{unicodemath_parens(parameter_one, options: options)}"
          end
        end
      end
    end
  end
end
