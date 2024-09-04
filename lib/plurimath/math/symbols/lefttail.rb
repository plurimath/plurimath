module Plurimath
  module Math
    module Symbols
      class Lefttail < Symbol
        INPUT = {
          unicodemath: [["&#x2919;"], parsing_wrapper(["lefttail"], lang: :unicode)],
          asciimath: [["&#x2919;"], parsing_wrapper(["lefttail"], lang: :asciimath)],
          mathml: ["&#x2919;"],
          latex: [["lefttail", "&#x2919;"]],
          omml: ["&#x2919;"],
          html: ["&#x2919;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\lefttail"
        end

        def to_asciimath(**)
          parsing_wrapper("lefttail", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2919;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2919;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2919;"
        end

        def to_html(**)
          "&#x2919;"
        end
      end
    end
  end
end
