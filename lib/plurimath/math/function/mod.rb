# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Mod < BinaryFunction
        def to_asciimath
          first_value = parameter_one&.to_asciimath
          second_value = parameter_two&.to_asciimath
          "#{first_value} mod #{second_value}"
        end

        def to_mathml_without_math_tag
          mrow_tag = Utility.ox_element("mrow")
          mo_tag = Utility.ox_element("mi") << "mod"
          first_value = parameter_one&.to_mathml_without_math_tag if parameter_one
          second_value = parameter_two&.to_mathml_without_math_tag if parameter_two
          Utility.update_nodes(
            mrow_tag,
            [
              first_value,
              mo_tag,
              second_value,
            ],
          )
        end

        def to_latex
          first_value = "{#{parameter_one.to_latex}}" if parameter_one
          second_value = "{#{parameter_two.to_latex}}" if parameter_two
          "#{first_value} \\mod #{second_value}"
        end

        def to_html
          first_value = "<i>#{parameter_one.to_html}</i>" if parameter_one
          second_value = "<i>#{parameter_two.to_html}</i>" if parameter_two
          "#{first_value}<i>mod</i>#{second_value}"
        end

        def to_omml_without_math_tag
          values = []
          values << parameter_one.insert_t_tag if parameter_one
          values << r_element("mod")
          values << parameter_two.insert_t_tag if parameter_two
          values
        end
      end
    end
  end
end
