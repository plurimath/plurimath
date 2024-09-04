module Plurimath
  module Math
    module Symbols
      class Bigtriangleleft < Symbol
        INPUT = {
          unicodemath: [["&#x2a1e;"], parsing_wrapper(["bigtriangleleft"], lang: :unicode)],
          asciimath: [["&#x2a1e;"], parsing_wrapper(["bigtriangleleft"], lang: :asciimath)],
          mathml: ["&#x2a1e;"],
          latex: [["bigtriangleleft", "&#x2a1e;"]],
          omml: ["&#x2a1e;"],
          html: ["&#x2a1e;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\bigtriangleleft"
        end

        def to_asciimath(**)
          parsing_wrapper("bigtriangleleft", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a1e;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a1e;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a1e;"
        end

        def to_html(**)
          "&#x2a1e;"
        end
      end
    end
  end
end
