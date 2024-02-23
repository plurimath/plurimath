# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Intent < BinaryFunction
        def to_mathml_without_math_tag
          first_value = parameter_one.to_mathml_without_math_tag
          first_value.attributes[:intent] = Utility.html_entity_to_unicode(parameter_two.value)
          first_value
        end
      end
    end
  end
end
