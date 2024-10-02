module Plurimath
  module Math
    module Symbols
      class Coprod < Symbol
        INPUT = {
          unicodemath: [["&#x2210;"], parsing_wrapper(["coprod"], lang: :unicode)],
          asciimath: [["&#x2210;"], parsing_wrapper(["coprod"], lang: :asciimath)],
          mathml: ["&#x2210;"],
          latex: [["coprod", "&#x2210;"]],
          omml: ["&#x2210;"],
          html: ["&#x2210;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\coprod"
        end

        def to_asciimath(**)
          parsing_wrapper("coprod", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2210;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2210;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2210;"
        end

        def to_html(**)
          "&#x2210;"
        end

        def is_nary_symbol?
          true
        end

        def nary_intent_name
          ":coproduct"
        end
      end
    end
  end
end
