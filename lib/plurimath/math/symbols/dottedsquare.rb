module Plurimath
  module Math
    module Symbols
      class Dottedsquare < Symbol
        INPUT = {
          unicodemath: [["&#x2b1a;"], parsing_wrapper(["dottedsquare"])],
          asciimath: [["&#x2b1a;"], parsing_wrapper(["dottedsquare"])],
          mathml: ["&#x2b1a;"],
          latex: [["dottedsquare", "&#x2b1a;"]],
          omml: ["&#x2b1a;"],
          html: ["&#x2b1a;"],
        }.freeze

        # output methods
        def to_latex
          "\\dottedsquare"
        end

        def to_asciimath
          parsing_wrapper("dottedsquare")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2b1a;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x2b1a;"
        end

        def to_omml_without_math_tag(_)
          "&#x2b1a;"
        end

        def to_html
          "&#x2b1a;"
        end
      end
    end
  end
end
