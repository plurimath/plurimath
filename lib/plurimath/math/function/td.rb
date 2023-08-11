# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Td < BinaryFunction
        def to_asciimath
          parameter_one.map(&:to_asciimath).join(" ")
        end

        def to_mathml_without_math_tag
          return "" if Utility.symbol_value(parameter_one.first, "|")

          td_attribute = parameter_two if parameter_two&.any?

          Utility.update_nodes(
            Utility.ox_element("mtd", attributes: td_attribute),
            parameter_one.map(&:to_mathml_without_math_tag),
          )
        end

        def to_latex
          return "" if Utility.symbol_value(parameter_one.first, "|")

          parameter_one.map(&:to_latex).join(" ")
        end

        def to_html
          first_value = parameter_one.map(&:to_html).join
          "<td>#{first_value}</td>"
        end

        def to_omml_without_math_tag(display_style)
          me = Utility.ox_element("e", namespace: "m")
          return [me] if parameter_one&.empty?

          Utility.update_nodes(
            me,
            Formula.new(parameter_one).omml_content(display_style),
          )
          [me]
        end
      end
    end
  end
end
