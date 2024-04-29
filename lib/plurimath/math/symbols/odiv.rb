module Plurimath
  module Math
    module Symbols
      class Odiv < Symbol
        INPUT = {
          unicodemath: [["&#x2a38;"], parsing_wrapper(["odiv"])],
          asciimath: [["&#x2a38;"], parsing_wrapper(["odiv"])],
          mathml: ["&#x2a38;"],
          latex: [["odiv", "&#x2a38;"]],
          omml: ["&#x2a38;"],
          html: ["&#x2a38;"],
        }.freeze

        # output methods
        def to_latex
          "\\odiv"
        end

        def to_asciimath
          parsing_wrapper("odiv")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2a38;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x2a38;"
        end

        def to_omml_without_math_tag(_)
          "&#x2a38;"
        end

        def to_html
          "&#x2a38;"
        end
      end
    end
  end
end
