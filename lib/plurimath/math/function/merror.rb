# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Merror < BinaryFunction
        def to_omml_without_math_tag(_); end
      end
    end
  end
end
