module Plurimath
  module Math
    module Symbols
      class Oiiint < Symbol
        INPUT = {
          unicodemath: [["&#x2230;"], parsing_wrapper(["oiiint"])],
          asciimath: [["&#x2230;"], parsing_wrapper(["oiiint"])],
          mathml: ["&#x2230;"],
          latex: [["oiiint", "&#x2230;"]],
          omml: ["&#x2230;"],
          html: ["&#x2230;"],
        }.freeze

        # output methods
        def to_latex
          "\\oiiint"
        end

        def to_asciimath
          parsing_wrapper("oiiint")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2230;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x2230;"
        end

        def to_omml_without_math_tag(_)
          "&#x2230;"
        end

        def to_html
          "&#x2230;"
        end

        def is_nary_symbol?
          true
        end
      end
    end
  end
end
