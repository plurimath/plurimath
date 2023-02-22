# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Sup < UnaryFunction
        def to_mathml_without_math_tag
          Utility.ox_element("mo") << "sup"
        end
      end
    end
  end
end
