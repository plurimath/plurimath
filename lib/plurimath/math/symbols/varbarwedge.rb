module Plurimath
  module Math
    module Symbols
      class Varbarwedge < Symbol
        INPUT = {
          unicodemath: [["&#x2305;"], parsing_wrapper(["varbarwedge"], lang: :unicode)],
          asciimath: [["&#x2305;"], parsing_wrapper(["varbarwedge"], lang: :asciimath)],
          mathml: ["&#x2305;"],
          latex: [["varbarwedge", "&#x2305;"]],
          omml: ["&#x2305;"],
          html: ["&#x2305;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\varbarwedge"
        end

        def to_asciimath(**)
          parsing_wrapper("varbarwedge", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2305;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2305;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2305;"
        end

        def to_html(**)
          "&#x2305;"
        end
      end
    end
  end
end
