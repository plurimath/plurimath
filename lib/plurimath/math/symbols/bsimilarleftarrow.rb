module Plurimath
  module Math
    module Symbols
      class Bsimilarleftarrow < Symbol
        INPUT = {
          unicodemath: [["&#x2b41;"], parsing_wrapper(["bsimilarleftarrow"], lang: :unicode)],
          asciimath: [["&#x2b41;"], parsing_wrapper(["bsimilarleftarrow"], lang: :asciimath)],
          mathml: ["&#x2b41;"],
          latex: [["bsimilarleftarrow", "&#x2b41;"]],
          omml: ["&#x2b41;"],
          html: ["&#x2b41;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\bsimilarleftarrow"
        end

        def to_asciimath(**)
          parsing_wrapper("bsimilarleftarrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2b41;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2b41;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2b41;"
        end

        def to_html(**)
          "&#x2b41;"
        end
      end
    end
  end
end
