# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Inf < BinaryFunction
        def to_latex
          first_value = "_{#{parameter_one.to_latex}}" if parameter_one
          second_value = "^{#{parameter_two.to_latex}}" if parameter_two
          "\\#{class_name}#{first_value}#{second_value}"
        end

        def to_mathml_without_math_tag
          first_value = Utility.ox_element("mo") << class_name
          if parameter_one || parameter_two
            value_array = [first_value]
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
              value_array,
            )
          else
            first_value
          end
        end

        def to_omml_without_math_tag
          return r_element("inf", rpr_tag: false) unless all_values_exist?

          inf = Symbol.new("inf")
          overset = Overset.new(inf, parameter_two)
          return Array(overset.to_omml_without_math_tag) unless parameter_one

          Array(Underset.new(overset, parameter_one)&.to_omml_without_math_tag)
        end
      end
    end
  end
end
