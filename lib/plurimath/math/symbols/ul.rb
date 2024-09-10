module Plurimath
  module Math
    module Symbols
      class Ul < Symbol
        INPUT = {
          unicodemath: [["_"]],
          asciimath: [["_"]],
          mathml: ["_"],
          latex: [["\\_"]],
          omml: ["_"],
          html: ["_"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\_"
        end

        def to_asciimath(**)
          "_"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("\\_")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mo") << "_"
        end

        def to_omml_without_math_tag(_, **)
          "_"
        end

        def to_html(**)
          "_"
        end
      end
    end
  end
end
