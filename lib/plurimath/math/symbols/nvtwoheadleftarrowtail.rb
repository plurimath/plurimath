module Plurimath
  module Math
    module Symbols
      class Nvtwoheadleftarrowtail < Symbol
        INPUT = {
          unicodemath: [["&#x2b3d;"], parsing_wrapper(["nVtwoheadleftarrowtail"], lang: :unicode)],
          asciimath: [["&#x2b3d;"], parsing_wrapper(["nVtwoheadleftarrowtail"], lang: :asciimath)],
          mathml: ["&#x2b3d;"],
          latex: [["nVtwoheadleftarrowtail", "&#x2b3d;"]],
          omml: ["&#x2b3d;"],
          html: ["&#x2b3d;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\nVtwoheadleftarrowtail"
        end

        def to_asciimath(**)
          parsing_wrapper("nVtwoheadleftarrowtail", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2b3d;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2b3d;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2b3d;"
        end

        def to_html(**)
          "&#x2b3d;"
        end
      end
    end
  end
end
