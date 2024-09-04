module Plurimath
  module Math
    module Symbols
      class Nvtwoheadrightarrowtail < Symbol
        INPUT = {
          unicodemath: [["&#x2918;"], parsing_wrapper(["nVtwoheadrightarrowtail"], lang: :unicode)],
          asciimath: [["&#x2918;"], parsing_wrapper(["nVtwoheadrightarrowtail"], lang: :asciimath)],
          mathml: ["&#x2918;"],
          latex: [["nVtwoheadrightarrowtail", "&#x2918;"]],
          omml: ["&#x2918;"],
          html: ["&#x2918;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\nVtwoheadrightarrowtail"
        end

        def to_asciimath(**)
          parsing_wrapper("nVtwoheadrightarrowtail", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2918;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2918;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2918;"
        end

        def to_html(**)
          "&#x2918;"
        end
      end
    end
  end
end
