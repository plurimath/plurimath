module Plurimath
  module Math
    module Symbols
      class Coprod < Symbol
        INPUT = {
          unicodemath: [["&#x2210;"], parsing_wrapper(["coprod"])],
          asciimath: [["&#x2210;"], parsing_wrapper(["coprod"])],
          mathml: ["&#x2210;"],
          latex: [["coprod", "&#x2210;"]],
          omml: ["&#x2210;"],
          html: ["&#x2210;"],
        }.freeze

        # output methods
        def to_latex
          "\\coprod"
        end

        def to_asciimath
          parsing_wrapper("coprod")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2210;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x2210;"
        end

        def to_omml_without_math_tag(_)
          "&#x2210;"
        end

        def to_html
          "&#x2210;"
        end

        def is_nary_symbol?
          true
        end
      end
    end
  end
end
