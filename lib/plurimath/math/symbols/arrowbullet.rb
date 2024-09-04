module Plurimath
  module Math
    module Symbols
      class Arrowbullet < Symbol
        INPUT = {
          unicodemath: [["&#x27a2;"], parsing_wrapper(["arrowbullet"], lang: :unicode)],
          asciimath: [["&#x27a2;"], parsing_wrapper(["arrowbullet"], lang: :asciimath)],
          mathml: ["&#x27a2;"],
          latex: [["arrowbullet", "&#x27a2;"]],
          omml: ["&#x27a2;"],
          html: ["&#x27a2;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\arrowbullet"
        end

        def to_asciimath(**)
          parsing_wrapper("arrowbullet", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x27a2;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x27a2;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x27a2;"
        end

        def to_html(**)
          "&#x27a2;"
        end
      end
    end
  end
end
