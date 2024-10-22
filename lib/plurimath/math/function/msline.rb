# frozen_string_literal: true

require_relative "unary_function"
require_relative "../../mathml/utility"

module Plurimath
  module Math
    module Function
      class Msline < UnaryFunction
        include Mathml::Utility

        def to_asciimath(**); end

        def to_latex(**); end

        def to_mathml_without_math_tag(intent, **)
          ox_element("msline")
        end

        def to_omml_without_math_tag(display_style, **);end

        def to_unicodemath(**);end
      end
    end
  end
end
