module Plurimath
  module Math
    module Symbols
      class Iint < Symbol
        INPUT = {
          unicodemath: [["&#x222c;"], parsing_wrapper(["iint"], lang: :unicode)],
          asciimath: [["&#x222c;"], parsing_wrapper(["iint"], lang: :asciimath)],
          mathml: ["&#x222c;"],
          latex: [["iint", "&#x222c;"]],
          omml: ["&#x222c;"],
          html: ["&#x222c;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\iint"
        end

        def to_asciimath(**)
          parsing_wrapper("iint", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x222c;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x222c;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x222c;"
        end

        def to_html(**)
          "&#x222c;"
        end

        def is_nary_symbol?
          true
        end

        def nary_intent_name
          ":double integral"
        end
      end
    end
  end
end
