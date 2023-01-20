# frozen_string_literal: true

module Plurimath
  module Math
    class Unicode < Symbol
      def to_mathml_without_math_tag
        Utility.ox_element("mo") << value
      end
    end
  end
end
