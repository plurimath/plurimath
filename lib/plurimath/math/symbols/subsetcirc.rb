module Plurimath
  module Math
    module Symbols
      class Subsetcirc < Symbol
        INPUT = {
          unicodemath: [["&#x27c3;"], parsing_wrapper(["subsetcirc"], lang: :unicode)],
          asciimath: [["&#x27c3;"], parsing_wrapper(["subsetcirc"], lang: :asciimath)],
          mathml: ["&#x27c3;"],
          latex: [["subsetcirc", "&#x27c3;"]],
          omml: ["&#x27c3;"],
          html: ["&#x27c3;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\subsetcirc"
        end

        def to_asciimath(**)
          parsing_wrapper("subsetcirc", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x27c3;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x27c3;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x27c3;"
        end

        def to_html(**)
          "&#x27c3;"
        end
      end
    end
  end
end
