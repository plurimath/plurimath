# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Ceil < UnaryFunction
        def to_latex
          "{\\lceil #{latex_value} \\rceil}"
        end
      end
    end
  end
end
