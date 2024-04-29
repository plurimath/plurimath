module Plurimath
  module Math
    module Symbols
      class Errbarblackcircle < Symbol
        INPUT = {
          unicodemath: [["&#x29f3;"], parsing_wrapper(["errbarblackcircle"])],
          asciimath: [["&#x29f3;"], parsing_wrapper(["errbarblackcircle"])],
          mathml: ["&#x29f3;"],
          latex: [["errbarblackcircle", "&#x29f3;"]],
          omml: ["&#x29f3;"],
          html: ["&#x29f3;"],
        }.freeze

        # output methods
        def to_latex
          "\\errbarblackcircle"
        end

        def to_asciimath
          parsing_wrapper("errbarblackcircle")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x29f3;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x29f3;"
        end

        def to_omml_without_math_tag(_)
          "&#x29f3;"
        end

        def to_html
          "&#x29f3;"
        end
      end
    end
  end
end
