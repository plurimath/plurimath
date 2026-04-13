# frozen_string_literal: true

module Plurimath
  class Mathml
    module Utility
      autoload :FormulaTransformation, "#{__dir__}/utility/formula_transformation"

      include FormulaTransformation
    end
  end
end
