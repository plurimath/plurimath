# frozen_string_literal: true

require_relative "ternary_function"

module Plurimath
  module Math
    module Function
      class PowerBase < TernaryFunction
        FUNCTION = {
          name: "subsup",
          first_value: "base",
          second_value: "subscript",
          third_value: "supscript",
        }.freeze

        def to_mathml_without_math_tag(intent)
          tag_name = parameter_one&.tag_name || "subsup"
          subsup_tag = ox_element("m#{tag_name}")
          new_arr = [
            validate_mathml_fields(parameter_one, intent),
            validate_mathml_fields(parameter_two, intent),
            validate_mathml_fields(parameter_three, intent),
          ]
          Utility.update_nodes(subsup_tag, new_arr)
        end

        def to_latex
          first_value  = parameter_one.to_latex if parameter_one
          second_value = parameter_two.to_latex if parameter_two
          third_value  = parameter_three.to_latex if parameter_three
          "#{first_value}_{#{second_value}}^{#{third_value}}"
        end

        def to_html
          first_value  = "<i>#{parameter_one.to_html}</i>" if parameter_one
          second_value = "<sub>#{parameter_two.to_html}</sub>" if parameter_two
          third_value  = "<sup>#{parameter_three.to_html}</sup>" if parameter_three
          "#{first_value}#{second_value}#{third_value}"
        end

        def to_omml_without_math_tag(display_style)
          return underover(display_style) if parameter_one&.omml_tag_name == "undOvr"

          ssubsup   = Utility.ox_element("sSubSup", namespace: "m")
          ssubsuppr = Utility.ox_element("sSubSupPr", namespace: "m")
          ssubsuppr << Utility.pr_element("ctrl", true, namespace: "m")
          Utility.update_nodes(
            ssubsup,
            [
              ssubsuppr,
              omml_parameter(parameter_one, display_style, tag_name: "e"),
              omml_parameter(parameter_two, display_style, tag_name: "sub"),
              omml_parameter(parameter_three, display_style, tag_name: "sup"),
            ],
          )
          [ssubsup]
        end

        def to_unicodemath
          first_value = sub_value if parameter_two
          second_value = sup_value if parameter_three
          if prime_unicode?(parameter_three)
            "#{parameter_one&.to_unicodemath}#{second_value}#{first_value}"
          else
            "#{parameter_one&.to_unicodemath}#{first_value}#{second_value}"
          end
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

          parameter_two.line_breaking(obj)
          if obj.value_exist?
            obj.update(
              self.class.new(nil, Utility.filter_values(obj.value), parameter_three)
            )
            self.parameter_three = nil
          end
        end

        def new_nary_function(fourth_value)
          Nary.new(parameter_one, parameter_two, parameter_three, fourth_value)
        end

        def is_nary_function?
          parameter_one.is_nary_function? || parameter_one.is_nary_symbol?
        end

        def mmultiscript(intent)
          [
            validate_mathml_fields(parameter_one, intent),
            validate_mathml_fields(parameter_two, intent),
            validate_mathml_fields(parameter_three, intent),
          ]
        end

        protected

        def sup_value
          if parameter_three.mini_sized? || prime_unicode?(parameter_three)
            parameter_three.to_unicodemath
          elsif parameter_three.is_a?(Math::Function::Power)
            "^#{parameter_three.to_unicodemath}"
          elsif parameter_one.is_a?(Math::Function::Power) && parameter_one&.prime_unicode?(parameter_one&.parameter_two)
            "^#{parameter_three.to_unicodemath}"
          else
            "^#{unicodemath_parens(parameter_three)}"
          end
        end

        def sub_value
          if parameter_two.mini_sized?
            parameter_two.to_unicodemath
          elsif parameter_two.is_a?(Math::Function::Base)
            "_#{parameter_two.to_unicodemath}"
          else
            "_#{unicodemath_parens(parameter_two)}"
          end
        end
      end
    end
  end
end
