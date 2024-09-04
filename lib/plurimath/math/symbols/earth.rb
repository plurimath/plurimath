module Plurimath
  module Math
    module Symbols
      class Earth < Symbol
        INPUT = {
          unicodemath: [["&#x2641;"], parsing_wrapper(["varEarth", "earth"], lang: :unicode)],
          asciimath: [["&#x2641;"], parsing_wrapper(["varEarth", "earth"], lang: :asciimath)],
          mathml: ["&#x2641;"],
          latex: [["varEarth", "earth", "&#x2641;"]],
          omml: ["&#x2641;"],
          html: ["&#x2641;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\varEarth"
        end

        def to_asciimath(**)
          parsing_wrapper("earth", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2641;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2641;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2641;"
        end

        def to_html(**)
          "&#x2641;"
        end
      end
    end
  end
end
