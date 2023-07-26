# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Sup < UnaryFunction
        def to_mathml_without_math_tag
          Utility.ox_element("mo") << "sup"
        end

        def to_omml_without_math_tag
          [r_element("sup"), omml_value]
        end
      end
    end
  end
end
