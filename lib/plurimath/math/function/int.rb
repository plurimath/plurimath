# frozen_string_literal: true

require_relative "ternary_function"

module Plurimath
  module Math
    module Function
      class Int < TernaryFunction
        attr_accessor :options
        FUNCTION = {
          name: "integral",
          first_value: "lower limit",
          second_value: "upper limit",
          third_value: "integrand"
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
          "int#{first_value}#{second_value} #{parameter_three&.to_asciimath}".strip
        end

        def to_latex
          first_value = "_{#{parameter_one.to_latex}}" if parameter_one
          second_value = "^{#{parameter_two.to_latex}}" if parameter_two
          "\\#{class_name}#{first_value}#{second_value} #{parameter_three&.to_latex}".strip
        end

        def to_mathml_without_math_tag
          base_element = (Utility.ox_element("mo") << invert_unicode_symbols.to_s)
          return base_element unless all_values_exist?

          msubsup_tag = Utility.ox_element("msubsup")
          Utility.update_nodes(
            msubsup_tag,
            [
              base_element,
              validate_mathml_tag(parameter_one),
              validate_mathml_tag(parameter_two),
            ],
          )
          return msubsup_tag if parameter_three.nil?

          Utility.update_nodes(
            Utility.ox_element("mrow"),
            [
              msubsup_tag,
              parameter_three&.to_mathml_without_math_tag,
            ].flatten.compact,
          )
        end

        def to_omml_without_math_tag(display_style)
          if all_values_exist?
            nary = Utility.ox_element("nary", namespace: "m")
            Utility.update_nodes(nary, nary_array(display_style))
            [nary]
          else
            r_tag = Utility.ox_element("r", namespace: "m")
            t_tag = Utility.ox_element("t", namespace: "m")
            r_tag << (t_tag << "&#x222b;")
            [r_tag]
          end
        end

        def to_unicodemath
          first_value = sub_value if parameter_one
          second_value = sup_value if parameter_two
          mask = options&.dig(:mask) if options&.key?(:mask)
          "∫#{mask}#{first_value}#{second_value}#{naryand_value(parameter_three)}"
        end

        def line_breaking(obj)
          parameter_one&.line_breaking(obj)
          if obj.value_exist?
            int = Int.new(Utility.filter_values(obj.value), parameter_two, parameter_three)
            int.hide_function_name = true
            obj.update(int)
            self.parameter_two = nil
            self.parameter_three = nil
            return
          end

          parameter_three&.line_breaking(obj)
          if obj.value_exist?
            obj.update(Utility.filter_values(obj.value))
          end
        end

        def nary_array(display_style)
          symbol = hide_function_name ? "" : "∫"
          [
            narypr(symbol, function_type: "subSup"),
            omml_parameter(parameter_one, display_style, tag_name: "sub"),
            omml_parameter(parameter_two, display_style, tag_name: "sup"),
            omml_parameter(parameter_three, display_style, tag_name: "e"),
          ]
        end

        def is_nary_function?
          true
        end

        protected

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
