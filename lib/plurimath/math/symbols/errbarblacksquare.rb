module Plurimath
  module Math
    module Symbols
      class Errbarblacksquare < Symbol
        INPUT = {
          unicodemath: [["&#x29ef;"], parsing_wrapper(["errbarblacksquare"], lang: :unicode)],
          asciimath: [["&#x29ef;"], parsing_wrapper(["errbarblacksquare"], lang: :asciimath)],
          mathml: ["&#x29ef;"],
          latex: [["errbarblacksquare", "&#x29ef;"]],
          omml: ["&#x29ef;"],
          html: ["&#x29ef;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\errbarblacksquare"
        end

        def to_asciimath(**)
          parsing_wrapper("errbarblacksquare", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x29ef;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x29ef;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x29ef;"
        end

        def to_html(**)
          "&#x29ef;"
        end
      end
    end
  end
end
