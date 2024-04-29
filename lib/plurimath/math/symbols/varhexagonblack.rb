module Plurimath
  module Math
    module Symbols
      class Varhexagonblack < Symbol
        INPUT = {
          unicodemath: [["&#x2b22;"], parsing_wrapper(["varhexagonblack"])],
          asciimath: [["&#x2b22;"], parsing_wrapper(["varhexagonblack"])],
          mathml: ["&#x2b22;"],
          latex: [["varhexagonblack", "&#x2b22;"]],
          omml: ["&#x2b22;"],
          html: ["&#x2b22;"],
        }.freeze

        # output methods
        def to_latex
          "\\varhexagonblack"
        end

        def to_asciimath
          parsing_wrapper("varhexagonblack")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2b22;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x2b22;"
        end

        def to_omml_without_math_tag(_)
          "&#x2b22;"
        end

        def to_html
          "&#x2b22;"
        end
      end
    end
  end
end
