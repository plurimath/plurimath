module Plurimath
  module Math
    module Symbols
      class Iiint < Symbol
        INPUT = {
          unicodemath: [["&#x222d;"], parsing_wrapper(["iiint"], lang: :unicode)],
          asciimath: [["&#x222d;"], parsing_wrapper(["iiint"], lang: :asciimath)],
          mathml: ["&#x222d;"],
          latex: [["iiint", "&#x222d;"]],
          omml: ["&#x222d;"],
          html: ["&#x222d;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\iiint"
        end

        def to_asciimath(**)
          parsing_wrapper("iiint", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x222d;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x222d;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x222d;"
        end

        def to_html(**)
          "&#x222d;"
        end

        def nary_intent_name
          ":triple integral"
        end

        def is_nary_symbol?
          true
        end
      end
    end
  end
end
