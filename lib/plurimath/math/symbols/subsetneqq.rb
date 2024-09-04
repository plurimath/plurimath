module Plurimath
  module Math
    module Symbols
      class Subsetneqq < Symbol
        INPUT = {
          unicodemath: [["&#x2acb;"], parsing_wrapper(["subsetneqq"], lang: :unicode)],
          asciimath: [["&#x2acb;"], parsing_wrapper(["subsetneqq"], lang: :asciimath)],
          mathml: ["&#x2acb;"],
          latex: [["subsetneqq", "&#x2acb;"]],
          omml: ["&#x2acb;"],
          html: ["&#x2acb;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\subsetneqq"
        end

        def to_asciimath(**)
          parsing_wrapper("subsetneqq", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2acb;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2acb;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2acb;"
        end

        def to_html(**)
          "&#x2acb;"
        end
      end
    end
  end
end
