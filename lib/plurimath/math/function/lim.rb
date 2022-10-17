# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Lim < BinaryFunction
        def to_asciimath
          first_value = "_(#{parameter_one.to_asciimath})" if parameter_one
          second_value = "^(#{parameter_two.to_asciimath})" if parameter_two
          "lim#{first_value}#{second_value}"
        end

        def to_latex
          first_value = "_{#{parameter_one.to_latex}}" if parameter_one
          second_value = "^{#{parameter_two.to_latex}}" if parameter_two
          "\\#{class_name}#{first_value}#{second_value}"
        end

        def to_omml_without_math_tag
          limupp = Utility.omml_element("limUpp", namespace: "m")
          limpr = Utility.omml_element("limUppPr", namespace: "m")
          limpr << Utility.pr_element("ctrl", namespace: "m")
          e_tag = Utility.omml_element("e", namespace: "m")
          e_tag << parameter_one.to_omml_without_math_tag
          lim = Utility.omml_element("lim", namespace: "m")
          lim << parameter_two.to_omml_without_math_tag
          Utility.update_nodes(
            limupp,
            [
              e_tag,
              lim,
            ],
          )
        end
      end
    end
  end
end
