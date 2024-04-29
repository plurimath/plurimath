module Plurimath
  module Math
    module Symbols
      class Errbarblacksquare < Symbol
        INPUT = {
          unicodemath: [["&#x29ef;"], parsing_wrapper(["errbarblacksquare"])],
          asciimath: [["&#x29ef;"], parsing_wrapper(["errbarblacksquare"])],
          mathml: ["&#x29ef;"],
          latex: [["errbarblacksquare", "&#x29ef;"]],
          omml: ["&#x29ef;"],
          html: ["&#x29ef;"],
        }.freeze

        # output methods
        def to_latex
          "\\errbarblacksquare"
        end

        def to_asciimath
          parsing_wrapper("errbarblacksquare")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x29ef;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x29ef;"
        end

        def to_omml_without_math_tag(_)
          "&#x29ef;"
        end

        def to_html
          "&#x29ef;"
        end
      end
    end
  end
end
