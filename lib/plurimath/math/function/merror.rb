# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Merror < UnaryFunction
        def to_asciimath;end

        def to_latex;end

        def to_mathml_without_math_tag
          merror = Utility.ox_element("merror")
          Utility.update_nodes(merror, mathml_value)
        end

        def to_omml_without_math_tag(_); end
      end
    end
  end
end
