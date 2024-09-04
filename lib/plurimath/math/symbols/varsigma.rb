module Plurimath
  module Math
    module Symbols
      class Varsigma < Symbol
        INPUT = {
          unicodemath: [["varsigma", "&#x3c2;"], parsing_wrapper(["upvarsigma"], lang: :unicode)],
          asciimath: [["&#x3c2;"], parsing_wrapper(["varsigma", "upvarsigma"], lang: :asciimath)],
          mathml: ["&#x3c2;"],
          latex: [["upvarsigma", "varsigma", "&#x3c2;"]],
          omml: ["&#x3c2;"],
          html: ["&#x3c2;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\upvarsigma"
        end

        def to_asciimath(**)
          parsing_wrapper("varsigma", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x3c2;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x3c2;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x3c2;"
        end

        def to_html(**)
          "&#x3c2;"
        end
      end
    end
  end
end
