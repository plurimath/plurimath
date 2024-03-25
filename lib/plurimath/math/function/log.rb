# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Log < BinaryFunction
        FUNCTION = {
          name: "function apply",
          first_value: "subscript",
          second_value: "supscript",
        }

        def to_asciimath
          first_value = "_#{wrapped(parameter_one)}" if parameter_one
          second_value = "^#{wrapped(parameter_two)}" if parameter_two
          "log#{first_value}#{second_value}"
        end

        def to_latex
          first_value = "_#{latex_wrapped(parameter_one)}" if parameter_one
          second_value = "^#{latex_wrapped(parameter_two)}" if parameter_two
          "\\log#{first_value}#{second_value}"
        end

        def to_html
          first_value = "<sub>#{parameter_one.to_html}</sub>" if parameter_one
          second_value = "<sup>#{parameter_two.to_html}</sup>" if parameter_two
          "<i>log</i>#{first_value}#{second_value}"
        end

        def to_omml_without_math_tag(display_style)
          return r_element("log", rpr_tag: false) unless all_values_exist?

          ssubsup   = Utility.ox_element("sSubSup", namespace: "m")
          ssubsuppr = Utility.ox_element("sSubSupPr", namespace: "m")
          ssubsuppr << Utility.pr_element("ctrl", true, namespace: "m")
          Utility.update_nodes(
            ssubsup,
            [
              ssubsuppr,
              e_parameter,
              omml_parameter(parameter_one, display_style, tag_name: "sub"),
              omml_parameter(parameter_two, display_style, tag_name: "sup"),
            ],
          )
          [ssubsup]
        end

        def to_mathml_without_math_tag
          first_value = ox_element("mi")
          first_value << "log" unless hide_function_name
          if parameter_one || parameter_two
            new_arr = [
              first_value,
              validate_mathml_fields(parameter_one),
              validate_mathml_fields(parameter_two),
            ]
            Utility.update_nodes(ox_element("msubsup"), new_arr)
          else
            first_value
          end
        end

        def to_unicodemath
          first_value = sub_value if parameter_one
          second_value = sup_value if parameter_two
          "log#{first_value}#{second_value}"
        end

        def line_breaking(obj)
          parameter_one&.line_breaking(obj)
          if obj.value_exist?
            log = self.class.new(Utility.filter_values(obj.value), parameter_two)
            self.parameter_two = nil
            log.hide_function_name = true
            obj.update(log)
          end
        end

        protected

        def e_parameter
          e_tag = Utility.ox_element("e", namespace: "m")
          return e_tag if hide_function_name

          e_tag << rpr_tag
        end

        def rpr_tag
          sty_atrs = { "m:val": "p" }
          sty_tag  = Utility.ox_element("sty", attributes: sty_atrs, namespace: "m")
          rpr_tag  = (Utility.ox_element("rPr", namespace: "m") << sty_tag)
          r_tag = Utility.ox_element("r", namespace: "m")
          t_tag = (Utility.ox_element("t", namespace: "m") << "log")
          Utility.update_nodes(r_tag, [rpr_tag, t_tag])
        end

        def sup_value
          if parameter_two&.mini_sized? || prime_unicode?(parameter_two)
            parameter_two.to_unicodemath
          elsif parameter_two.is_a?(Math::Function::Power)
            "^#{parameter_two.to_unicodemath}"
          else
            "^#{unicodemath_parens(parameter_two)}"
          end
        end

        def sub_value
          if parameter_one&.mini_sized?
            parameter_one.to_unicodemath
          elsif parameter_one.is_a?(Math::Function::Base)
            "_#{parameter_one.to_unicodemath}"
          else
            "_#{unicodemath_parens(parameter_one)}"
          end
        end
      end
    end
  end
end
