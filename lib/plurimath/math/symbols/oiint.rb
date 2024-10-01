module Plurimath
  module Math
    module Symbols
      class Oiint < Symbol
        INPUT = {
          unicodemath: [["&#x222f;"], parsing_wrapper(["dbloint", "oiint"], lang: :unicode)],
          asciimath: [["&#x222f;"], parsing_wrapper(["dbloint", "oiint"], lang: :asciimath)],
          mathml: ["&#x222f;"],
          latex: [["dbloint", "oiint", "&#x222f;"]],
          omml: ["&#x222f;"],
          html: ["&#x222f;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\dbloint"
        end

        def to_asciimath(**)
          parsing_wrapper("oiint", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x222f;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mo") << "&#x222f;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x222f;"
        end

        def to_html(**)
          "&#x222f;"
        end

        def is_nary_symbol?
          true
        end

        def nary_intent_name
          ":surface integral"
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
