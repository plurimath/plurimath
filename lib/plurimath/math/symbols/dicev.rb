module Plurimath
  module Math
    module Symbols
      class Dicev < Symbol
        INPUT = {
          unicodemath: [["&#x2684;"], parsing_wrapper(["dicev"], lang: :unicode)],
          asciimath: [["&#x2684;"], parsing_wrapper(["dicev"], lang: :asciimath)],
          mathml: ["&#x2684;"],
          latex: [["dicev", "&#x2684;"]],
          omml: ["&#x2684;"],
          html: ["&#x2684;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\dicev"
        end

        def to_asciimath(**)
          parsing_wrapper("dicev", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2684;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2684;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2684;"
        end

        def to_html(**)
          "&#x2684;"
        end
      end
    end
  end
end
