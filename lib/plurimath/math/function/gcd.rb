# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Gcd < UnaryFunction
        def validate_function_formula
          false
        end

        def evaluate(evaluator)
          values = evaluator.function_arguments(parameter_one)
          unless values.all?(Integer)
            raise Evaluation::MathDomainError, "gcd requires integer arguments"
          end

          values.reduce(:gcd)
        end

        def to_omml_without_math_tag(display_style, options:)
          array = []
          array << r_element("gcd", rpr_tag: false) unless hide_function_name
          array += Array(omml_value(display_style, options: options))
          array
        end
      end
    end
  end
end
