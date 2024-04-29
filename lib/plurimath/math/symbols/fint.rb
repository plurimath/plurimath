module Plurimath
  module Math
    module Symbols
      class Fint < Symbol
        INPUT = {
          unicodemath: [["&#x2a0f;"], parsing_wrapper(["fint"])],
          asciimath: [["&#x2a0f;"], parsing_wrapper(["fint"])],
          mathml: ["&#x2a0f;"],
          latex: [["fint", "&#x2a0f;"]],
          omml: ["&#x2a0f;"],
          html: ["&#x2a0f;"],
        }.freeze

        # output methods
        def to_latex
          "\\fint"
        end

        def to_asciimath
          parsing_wrapper("fint")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2a0f;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x2a0f;"
        end

        def to_omml_without_math_tag(_)
          "&#x2a0f;"
        end

        def to_html
          "&#x2a0f;"
        end
      end
    end
  end
end
