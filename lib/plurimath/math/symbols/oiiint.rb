module Plurimath
  module Math
    module Symbols
      class Oiiint < Symbol
        INPUT = {
          unicodemath: [["&#x2230;"], parsing_wrapper(["oiiint"], lang: :unicode)],
          asciimath: [["&#x2230;"], parsing_wrapper(["oiiint"], lang: :asciimath)],
          mathml: ["&#x2230;"],
          latex: [["oiiint", "&#x2230;"]],
          omml: ["&#x2230;"],
          html: ["&#x2230;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\oiiint"
        end

        def to_asciimath(**)
          parsing_wrapper("oiiint", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2230;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mo") << "&#x2230;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2230;"
        end

        def to_html(**)
          "&#x2230;"
        end

        def is_nary_symbol?
          true
        end

        def nary_intent_name
          ":volume integral"
        end

        def tag_name
          "underover"
        end

        def omml_tag_name
          "undOvr"
        end
      end
    end
  end
end
