module Plurimath
  module Math
    module Symbols
      class Subsetneq < Symbol
        INPUT = {
          unicodemath: [["subsetneq", "&#x228a;"], parsing_wrapper(["varsubsetneq"], lang: :unicode)],
          asciimath: [["&#x228a;"], parsing_wrapper(["subsetneq", "varsubsetneq"], lang: :asciimath)],
          mathml: ["&#x228a;"],
          latex: [["varsubsetneq", "subsetneq", "&#x228a;"]],
          omml: ["&#x228a;"],
          html: ["&#x228a;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\varsubsetneq"
        end

        def to_asciimath(**)
          parsing_wrapper("subsetneq", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x228a;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x228a;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x228a;"
        end

        def to_html(**)
          "&#x228a;"
        end
      end
    end
  end
end
