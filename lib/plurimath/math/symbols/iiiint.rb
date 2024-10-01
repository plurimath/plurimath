module Plurimath
  module Math
    module Symbols
      class Iiiint < Symbol
        INPUT = {
          unicodemath: [["&#x2a0c;"], parsing_wrapper(["iiiint"], lang: :unicode)],
          asciimath: [["&#x2a0c;"], parsing_wrapper(["iiiint"], lang: :asciimath)],
          mathml: ["&#x2a0c;"],
          latex: [["iiiint", "&#x2a0c;"]],
          omml: ["&#x2a0c;"],
          html: ["&#x2a0c;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\iiiint"
        end

        def to_asciimath(**)
          parsing_wrapper("iiiint", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a0c;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a0c;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a0c;"
        end

        def to_html(**)
          "&#x2a0c;"
        end

        def is_nary_symbol?
          true
        end

        def nary_intent_name
          ":quadruple integral"
        end
      end
    end
  end
end
