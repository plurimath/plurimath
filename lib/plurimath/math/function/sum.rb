# frozen_string_literal: true

require_relative "ternary_function"

module Plurimath
  module Math
    module Function
      class Sum < TernaryFunction
        attr_accessor :options
        FUNCTION = {
          name: "summation",
          first_value: "subscript",
          second_value: "supscript",
          third_value: "term",
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

        def to_asciimath(options:)
          first_value = "_#{wrapped(parameter_one, options: options)}" if parameter_one
          second_value = "^#{wrapped(parameter_two, options: options)}" if parameter_two
          "sum#{first_value}#{second_value} #{parameter_three&.to_asciimath(options: options)}".strip
        end

        def to_latex(options:)
          first_value = "_{#{parameter_one.to_latex(options: options)}}" if parameter_one
          second_value = "^{#{parameter_two.to_latex(options: options)}}" if parameter_two
          "\\sum#{first_value}#{second_value} #{parameter_three&.to_latex(options: options)}".strip
        end

        def to_mathml_without_math_tag(intent, options:)
          first_value = ox_element("mo")
          first_value << invert_unicode_symbols.to_s unless hide_function_name
          return first_value unless all_values_exist?

          munderover_tag = Utility.update_nodes(
            sum_tag,
            [
              first_value,
              parameter_one&.to_mathml_without_math_tag(intent, options: options),
              parameter_two&.to_mathml_without_math_tag(intent, options: options),
            ],
          )
          return munderover_tag if parameter_three.nil?

          mrow = ox_element("mrow")
          Utility.update_nodes(
            mrow,
            [
              munderover_tag,
              wrap_mrow(parameter_three&.to_mathml_without_math_tag(intent, options: options), intent),
            ],
          )
          ternary_intentify(mrow, intent)
        end

        def to_html(options:)
          first_value = "<sub>#{parameter_one.to_html(options: options)}</sub>" if parameter_one
          second_value = "<sup>#{parameter_two.to_html(options: options)}</sup>" if parameter_two
          "<i>&sum;</i>#{first_value}#{second_value}"
        end

        def to_unicodemath(options:)
          first_value = "_#{unicodemath_parens(parameter_one, options: options)}" if parameter_one
          second_value = "^#{unicodemath_parens(parameter_two, options: options)}" if parameter_two
          mask = self.options&.dig(:mask) if self.options&.key?(:mask)
          "∑#{mask}#{first_value}#{second_value}#{naryand_value(parameter_three, options: options)}"
        end

        def to_omml_without_math_tag(display_style, options:)
          return r_element("&#x2211;", rpr_tag: false) unless all_values_exist?

          nary = Utility.ox_element("nary", namespace: "m")
          Utility.update_nodes(
            nary,
            [
              narypr(hide_function_name ? "" : "∑"),
              omml_parameter(parameter_one, display_style, tag_name: "sub", options: options),
              omml_parameter(parameter_two, display_style, tag_name: "sup", options: options),
              omml_parameter(parameter_three, display_style, tag_name: "e", options: options),
            ],
          )
          [nary]
        end

        def omml_tag_name
          "undOvr"
        end

        def nary_attr_value(**)
          "∑"
        end

        def line_breaking(obj)
          parameter_one&.line_breaking(obj)
          if obj.value_exist?
            sum = self.class.new(Utility.filter_values(obj.value), parameter_two, parameter_three)
            sum.hide_function_name = true
            obj.update(sum)
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

        def intent_names
          { name: ":sum"}
        end

        private

        def sum_tag
          tag_name = if parameter_two && parameter_one
                       "underover"
                     else
                       parameter_one ? "under" : "over"
                     end
          ox_element("m#{tag_name}")
        end

        def ternary_intentify(tag, intent)
          intentify(
            tag,
            intent,
            func_name: :naryand,
            intent_name: intent_names[:name],
          )
        end
      end
    end
  end
end
