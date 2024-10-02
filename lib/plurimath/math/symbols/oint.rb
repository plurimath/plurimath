module Plurimath
  module Math
    module Symbols
      class Oint < Symbol
        INPUT = {
          unicodemath: [["&#x222e;"]],
          asciimath: [["&#x222e;"]],
          mathml: ["&#x222e;"],
          latex: [["&#x222e;"]],
          omml: ["&#x222e;"],
          html: ["&#x222e;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\oint"
        end

        def to_asciimath(**)
          "oint"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x222e;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mo") << "&#x222e;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x222e;"
        end

        def to_html(**)
          "&#x222e;"
        end

        def is_nary_symbol?
          true
        end

        def nary_intent_name
          ":contour integral"
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
