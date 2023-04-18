# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Sum < BinaryFunction
        def to_asciimath
          first_value = "_#{wrapped(parameter_one)}" if parameter_one
          second_value = "^#{wrapped(parameter_two)}" if parameter_two
          "sum#{first_value}#{second_value}"
        end

        def to_latex
          first_value = "_{#{parameter_one.to_latex}}" if parameter_one
          second_value = "^{#{parameter_two.to_latex}}" if parameter_two
          "\\sum#{first_value}#{second_value}"
        end

        def to_mathml_without_math_tag
          first_value = Utility.ox_element("mo") << invert_unicode_symbols.to_s
          if parameter_one || parameter_two
            value_array = []
            value_array << parameter_one&.to_mathml_without_math_tag
            value_array << parameter_two&.to_mathml_without_math_tag
            tag_name = if parameter_two && parameter_one
                         "underover"
                       else
                         parameter_one ? "under" : "over"
                       end
            munderover_tag = Utility.ox_element("m#{tag_name}")
            Utility.update_nodes(
              munderover_tag,
              value_array.insert(0, first_value),
            )
          else
            first_value
          end
        end

        def to_html
          first_value = "<sub>#{parameter_one.to_html}</sub>" if parameter_one
          second_value = "<sup>#{parameter_two.to_html}</sup>" if parameter_two
          "<i>&sum;</i>#{first_value}#{second_value}"
        end

        def to_omml_without_math_tag
          limupp   = Utility.ox_element("limLow", namespace: "m")
          limupppr = Utility.ox_element("limUppPr", namespace: "m")
          me = (Utility.ox_element("e", namespace: "m") << omml_first_value) if parameter_one
          lim = (Utility.ox_element("lim", namespace: "m") << omml_second_value) if parameter_two
          Utility.update_nodes(limupp, [limupppr, me, lim])
        end

        protected

        def omml_first_value
          return parameter_one&.to_omml_without_math_tag unless parameter_one&.is_a?(Math::Symbol)

          mt = Utility.ox_element("t", namespace: "m")
          mt << parameter_one.to_omml_without_math_tag if parameter_one
          mt
        end

        def omml_second_value
          return parameter_two&.to_omml_without_math_tag unless parameter_two&.is_a?(Math::Symbol)

          mt = Utility.ox_element("t", namespace: "m")
          mt << parameter_two.to_omml_without_math_tag if parameter_two
          mt
        end
      end
    end
  end
end
