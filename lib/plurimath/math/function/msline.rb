# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Msline < UnaryFunction
        def to_asciimath(**); end

        def to_latex(**); end

        def to_mathml_without_math_tag(_intent, **)
          ox_element("msline")
        end

        def to_omml_without_math_tag(display_style, **); end

        def to_unicodemath(**); end
      end
    end
  end
end
