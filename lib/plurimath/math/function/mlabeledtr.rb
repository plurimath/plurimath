# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Mlabeledtr < BinaryFunction
        def to_mathml_without_math_tag
          table = ox_element("mtable")
          mlabeledtr = ox_element(class_name)
          labeledtr_td(mlabeledtr, parameter_two.to_mathml_without_math_tag)
          labeledtr_td(mlabeledtr, parameter_one.to_mathml_without_math_tag)
          table << mlabeledtr
        end

        def to_unicodemath
          "#{parameter_one&.to_unicodemath}##{parameter_two&.value}"
        end

        protected

        def labeledtr_td(tr, value)
          tr << (ox_element("mtd") << value)
        end
      end
    end
  end
end
