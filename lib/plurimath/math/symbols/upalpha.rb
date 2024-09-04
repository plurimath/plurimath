module Plurimath
  module Math
    module Symbols
      class Upalpha < Symbol
        INPUT = {
          unicodemath: [["&#x391;"], parsing_wrapper(["upAlpha"], lang: :unicode)],
          asciimath: [["&#x391;"], parsing_wrapper(["upAlpha"], lang: :asciimath)],
          mathml: ["&#x391;"],
          latex: [["upAlpha", "&#x391;"]],
          omml: ["&#x391;"],
          html: ["&#x391;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\upAlpha"
        end

        def to_asciimath(**)
          parsing_wrapper("upAlpha", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x391;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x391;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x391;"
        end

        def to_html(**)
          "&#x391;"
        end
      end
    end
  end
end
