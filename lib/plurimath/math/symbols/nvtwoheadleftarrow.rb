module Plurimath
  module Math
    module Symbols
      class Nvtwoheadleftarrow < Symbol
        INPUT = {
          unicodemath: [["&#x2b35;"], parsing_wrapper(["nVtwoheadleftarrow"], lang: :unicode)],
          asciimath: [["&#x2b35;"], parsing_wrapper(["nVtwoheadleftarrow"], lang: :asciimath)],
          mathml: ["&#x2b35;"],
          latex: [["nVtwoheadleftarrow", "&#x2b35;"]],
          omml: ["&#x2b35;"],
          html: ["&#x2b35;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\nVtwoheadleftarrow"
        end

        def to_asciimath(**)
          parsing_wrapper("nVtwoheadleftarrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2b35;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2b35;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2b35;"
        end

        def to_html(**)
          "&#x2b35;"
        end
      end
    end
  end
end
