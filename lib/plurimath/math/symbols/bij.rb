module Plurimath
  module Math
    module Symbols
      class Bij < Symbol
        INPUT = {
          unicodemath: [["&#x2916;"], parsing_wrapper(["twoheadrightarrowtail", ">->>", "bij"])],
          asciimath: [["twoheadrightarrowtail", ">->>", "&#x2916;"], parsing_wrapper(["bij"])],
          mathml: ["&#x2916;"],
          latex: [["twoheadrightarrowtail", "bij", "&#x2916;"], parsing_wrapper([">->>"])],
          omml: ["&#x2916;"],
          html: ["&#x2916;"],
        }.freeze

        # output methods
        def to_latex
          "\\twoheadrightarrowtail"
        end

        def to_asciimath
          parsing_wrapper("bij")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2916;")
        end

        def to_mathml_without_math_tag(_)
          ox_element("mi") << "&#x2916;"
        end

        def to_omml_without_math_tag(_)
          "&#x2916;"
        end

        def to_html
          "&#x2916;"
        end
      end
    end
  end
end
