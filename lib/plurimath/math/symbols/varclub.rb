module Plurimath
  module Math
    module Symbols
      class Varclub < Symbol
        INPUT = {
          unicodemath: [["&#x2667;"], parsing_wrapper(["varclubsuit", "varclub"], lang: :unicode)],
          asciimath: [["&#x2667;"], parsing_wrapper(["varclubsuit", "varclub"], lang: :asciimath)],
          mathml: ["&#x2667;"],
          latex: [["varclubsuit", "varclub", "&#x2667;"]],
          omml: ["&#x2667;"],
          html: ["&#x2667;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\varclubsuit"
        end

        def to_asciimath(**)
          parsing_wrapper("varclub", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2667;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2667;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2667;"
        end

        def to_html(**)
          "&#x2667;"
        end
      end
    end
  end
end
