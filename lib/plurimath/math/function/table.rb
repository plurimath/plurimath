# frozen_string_literal: true

require_relative "ternary_function"

module Plurimath
  module Math
    module Function
      class Table < TernaryFunction
        def to_asciimath
          first_value  = parameter_one.map(&:to_asciimath).join(",")
          second_value = parameter_two.nil? ? "[" : parameter_two
          third_value  = parameter_three.nil? ? "]" : parameter_three
          "#{second_value}#{first_value}#{third_value}"
        end

        def to_mathml_without_math_tag
          table_value = parameter_one.map(&:to_mathml_without_math_tag).join
          if Latex::Constants::PARENTHESIS.key?(parameter_two) || parameter_two == "|"
            "<mfenced open='#{parameter_two}' close='#{parameter_three}'>"\
              "<mtable>#{table_value}</mtable></mfenced>"
          elsif parameter_two == "norm["
            "<mo>&#x2225;</mo>#{table_value}<mo>&#x2225;</mo>"
          else
            "<mtable>#{table_value}</mtable>"
          end
        end

        def to_latex
          first_value = parameter_one&.map(&:to_latex)&.join("\\\\")
          environment = latex_environment
          divider     = "{#{parameter_three&.map(&:to_latex).join}}" if environment == "array"
          "\\begin{#{environment}}#{divider}#{first_value}\\end{#{environment}}"
        end

        def latex_environment
          matrices_hash = Latex::Constants::ENVIRONMENTS
          matrices_hash.invert[parameter_two] if matrices_hash.value?(parameter_two)
        end
      end
    end
  end
end
