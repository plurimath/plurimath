module Plurimath
  module Math
    module Symbols
      class Intclockwise < Symbol
        INPUT = {
          unicodemath: [["&#x2231;"], parsing_wrapper(["intclockwise"], lang: :unicode)],
          asciimath: [["&#x2231;"], parsing_wrapper(["intclockwise"], lang: :asciimath)],
          mathml: ["&#x2231;"],
          latex: [["intclockwise", "&#x2231;"]],
          omml: ["&#x2231;"],
          html: ["&#x2231;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\intclockwise"
        end

        def to_asciimath(**)
          parsing_wrapper("intclockwise", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2231;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2231;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2231;"
        end

        def to_html(**)
          "&#x2231;"
        end

        def is_nary_symbol?
          true
        end

        def nary_intent_name
          ":clockwise contour integral"
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
