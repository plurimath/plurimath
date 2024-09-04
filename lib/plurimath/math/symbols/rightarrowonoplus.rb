module Plurimath
  module Math
    module Symbols
      class Rightarrowonoplus < Symbol
        INPUT = {
          unicodemath: [["&#x27f4;"], parsing_wrapper(["rightarrowonoplus"], lang: :unicode)],
          asciimath: [["&#x27f4;"], parsing_wrapper(["rightarrowonoplus"], lang: :asciimath)],
          mathml: ["&#x27f4;"],
          latex: [["rightarrowonoplus", "&#x27f4;"]],
          omml: ["&#x27f4;"],
          html: ["&#x27f4;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\rightarrowonoplus"
        end

        def to_asciimath(**)
          parsing_wrapper("rightarrowonoplus", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x27f4;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x27f4;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x27f4;"
        end

        def to_html(**)
          "&#x27f4;"
        end
      end
    end
  end
end
