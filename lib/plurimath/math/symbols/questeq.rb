module Plurimath
  module Math
    module Symbols
      class Questeq < Symbol
        INPUT = {
          unicodemath: [["&#x225f;"], parsing_wrapper(["questeq"])],
          asciimath: [["&#x225f;"], parsing_wrapper(["questeq"])],
          mathml: ["&#x225f;"],
          latex: [["questeq", "&#x225f;"]],
          omml: ["&#x225f;"],
          html: ["&#x225f;"],
        }.freeze

        # output methods
        def to_latex
          "\\questeq"
        end

        def to_asciimath
          parsing_wrapper("questeq")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x225f;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x225f;"
        end

        def to_omml_without_math_tag(_)
          "&#x225f;"
        end

        def to_html
          "&#x225f;"
        end
      end
    end
  end
end
