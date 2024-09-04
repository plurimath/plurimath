module Plurimath
  module Math
    module Symbols
      class Nvtwoheadrightarrow < Symbol
        INPUT = {
          unicodemath: [["&#x2901;"], parsing_wrapper(["nVtwoheadrightarrow"], lang: :unicode)],
          asciimath: [["&#x2901;"], parsing_wrapper(["nVtwoheadrightarrow"], lang: :asciimath)],
          mathml: ["&#x2901;"],
          latex: [["nVtwoheadrightarrow", "&#x2901;"]],
          omml: ["&#x2901;"],
          html: ["&#x2901;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\nVtwoheadrightarrow"
        end

        def to_asciimath(**)
          parsing_wrapper("nVtwoheadrightarrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2901;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2901;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2901;"
        end

        def to_html(**)
          "&#x2901;"
        end
      end
    end
  end
end
