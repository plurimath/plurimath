module Plurimath
  module Math
    module Symbols
      class Squareulquad < Symbol
        INPUT = {
          unicodemath: [["&#x25f0;"], parsing_wrapper(["squareulquad"])],
          asciimath: [["&#x25f0;"], parsing_wrapper(["squareulquad"])],
          mathml: ["&#x25f0;"],
          latex: [["squareulquad", "&#x25f0;"]],
          omml: ["&#x25f0;"],
          html: ["&#x25f0;"],
        }.freeze

        # output methods
        def to_latex
          "\\squareulquad"
        end

        def to_asciimath
          parsing_wrapper("squareulquad")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x25f0;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x25f0;"
        end

        def to_omml_without_math_tag(_)
          "&#x25f0;"
        end

        def to_html
          "&#x25f0;"
        end
      end
    end
  end
end
