module Plurimath
  module Math
    module Symbols
      class Similarleftarrow < Symbol
        INPUT = {
          unicodemath: [["&#x2b49;"], parsing_wrapper(["similarleftarrow"], lang: :unicode)],
          asciimath: [["&#x2b49;"], parsing_wrapper(["similarleftarrow"], lang: :asciimath)],
          mathml: ["&#x2b49;"],
          latex: [["similarleftarrow", "&#x2b49;"]],
          omml: ["&#x2b49;"],
          html: ["&#x2b49;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\similarleftarrow"
        end

        def to_asciimath(**)
          parsing_wrapper("similarleftarrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2b49;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2b49;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2b49;"
        end

        def to_html(**)
          "&#x2b49;"
        end
      end
    end
  end
end
