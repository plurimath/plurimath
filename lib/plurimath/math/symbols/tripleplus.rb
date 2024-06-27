module Plurimath
  module Math
    module Symbols
      class Tripleplus < Symbol
        INPUT = {
          unicodemath: [["&#x29fb;"], parsing_wrapper(["tripleplus"])],
          asciimath: [["&#x29fb;"], parsing_wrapper(["tripleplus"])],
          mathml: ["&#x29fb;"],
          latex: [["tripleplus", "&#x29fb;"]],
          omml: ["&#x29fb;"],
          html: ["&#x29fb;"],
        }.freeze

        # output methods
        def to_latex
          "\\tripleplus"
        end

        def to_asciimath
          parsing_wrapper("tripleplus")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x29fb;")
        end

        def to_mathml_without_math_tag(_)
          ox_element("mi") << "&#x29fb;"
        end

        def to_omml_without_math_tag(_)
          "&#x29fb;"
        end

        def to_html
          "&#x29fb;"
        end
      end
    end
  end
end
