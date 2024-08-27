# frozen_string_literal: true

require_relative "ternary_function"

module Plurimath
  module Math
    module Function
      class Oint < TernaryFunction
        attr_accessor :options
        FUNCTION = {
          name: "contour integral",
          first_value: "subscript",
          second_value: "supscript",
        }.freeze

        def initialize(parameter_one = nil,
                       parameter_two = nil,
                       parameter_three = nil,
                       options = {})
          super(parameter_one, parameter_two, parameter_three)
          @options = options unless options&.empty?
        end

        def ==(object)
          super(object) && object.options == options
        end

        def to_asciimath
          first_value = "_#{wrapped(parameter_one)}" if parameter_one
          second_value = "^#{wrapped(parameter_two)}" if parameter_two
          "oint#{first_value}#{second_value} #{parameter_three&.to_asciimath}".strip
        end

        def to_latex
          first_value = "_#{latex_wrapped(parameter_one)}" if parameter_one
          second_value = "^#{latex_wrapped(parameter_two)}" if parameter_two
          "\\#{class_name}#{first_value}#{second_value} #{parameter_three&.to_latex}".strip
        end

        def to_mathml_without_math_tag(intent, options:)
          mo_tag = ox_element("mo")
          mo_tag << invert_unicode_symbols.to_s unless hide_function_name
          return mo_tag unless all_values_exist?

          tag_name = if parameter_one && parameter_two
                       "subsup"
                     else
                       parameter_one ? "sub" : "sup"
                     end
          oint_tag = ox_element("m#{tag_name}")
          Utility.update_nodes(
            oint_tag,
            [
              mo_tag,
              parameter_one&.to_mathml_without_math_tag(intent, options: options),
              parameter_two&.to_mathml_without_math_tag(intent, options: options),
            ],
          )
          return ternary_intentify(oint_tag, intent) unless parameter_three

          ternary_intentify(
            Utility.update_nodes(
              ox_element("mrow"),
              [
                oint_tag,
                wrap_mrow(parameter_three&.to_mathml_without_math_tag(intent, options: options), intent),
              ],
            ),
            intent,
          )
        end

        def to_omml_without_math_tag(display_style)
          if all_values_exist?
            nary = Utility.ox_element("nary", namespace: "m")
            Utility.update_nodes(
              nary,
              [
                narypr((hide_function_name ? "" : "∮"), function_type: "subSup"),
                omml_parameter(parameter_one, display_style, tag_name: "sub"),
                omml_parameter(parameter_two, display_style, tag_name: "sup"),
                omml_parameter(parameter_three, display_style, tag_name: "e"),
              ],
            )
            [nary]
          else
            r_tag = Utility.ox_element("r", namespace: "m")
            t_tag = Utility.ox_element("t", namespace: "m")
            r_tag << (t_tag << "&#x222e;")
            [r_tag]
          end
        end

        def to_unicodemath
          first_value = "_#{unicodemath_parens(parameter_one)}" if parameter_one
          second_value = "^#{unicodemath_parens(parameter_two)}" if parameter_two
          mask = options&.dig(:mask) if options&.key?(:mask)
          "∮#{mask}#{first_value}#{second_value}#{naryand_value(parameter_three)}"
        end

        def line_breaking(obj)
          parameter_one&.line_breaking(obj)
          if obj.value_exist?
            oint = self.class.new(Utility.filter_values(obj.value), parameter_two, parameter_three)
            oint.hide_function_name = true
            obj.update(oint)
            self.parameter_two = nil
            self.parameter_three = nil
            return
          end

          parameter_three&.line_breaking(obj)
          if obj.value_exist?
            obj.update(Utility.filter_values(obj.value))
          end
        end

        def is_nary_function?
          true
        end

        private

        def ternary_intentify(tag, intent)
          intentify(
            tag,
            intent,
            func_name: :naryand,
            intent_name: "contour integral",
          )
        end
      end
    end
  end
end
