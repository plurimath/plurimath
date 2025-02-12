# frozen_string_literal: true

require_relative "unary_function"
require_relative "../../mathml/utility"

module Plurimath
  module Math
    module Function
      class None < UnaryFunction
        include Mathml::Utility

        def to_asciimath(**); end

        def to_latex(**); end

        def to_mathml_without_math_tag(_, **)
          ox_element("none")
        end

        def to_omml_without_math_tag(_, **)
          empty_tag
        end

        def to_unicodemath(**); end
      end
    end
  end
end
