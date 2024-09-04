module Plurimath
  module Math
    module Symbols
      class Vysmwhtcircle < Symbol
        INPUT = {
          unicodemath: [["circ", "&#x2218;"], parsing_wrapper(["@", "vysmwhtcircle"], lang: :unicode)],
          asciimath: [["circ", "@", "&#x2218;"], parsing_wrapper(["vysmwhtcircle"], lang: :asciimath)],
          mathml: ["&#x2218;"],
          latex: [["vysmwhtcircle", "circ", "&#x2218;"], parsing_wrapper(["@"], lang: :latex)],
          omml: ["&#x2218;"],
          html: ["&#x2218;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\vysmwhtcircle"
        end

        def to_asciimath(**)
          "circ"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2218;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2218;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2218;"
        end

        def to_html(**)
          "&#x2218;"
        end
      end
    end
  end
end
