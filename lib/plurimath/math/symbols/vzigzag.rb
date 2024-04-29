module Plurimath
  module Math
    module Symbols
      class Vzigzag < Symbol
        INPUT = {
          unicodemath: [["&#x299a;"], parsing_wrapper(["vzigzag"])],
          asciimath: [["&#x299a;"], parsing_wrapper(["vzigzag"])],
          mathml: ["&#x299a;"],
          latex: [["vzigzag", "&#x299a;"]],
          omml: ["&#x299a;"],
          html: ["&#x299a;"],
        }.freeze

        # output methods
        def to_latex
          "\\vzigzag"
        end

        def to_asciimath
          parsing_wrapper("vzigzag")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x299a;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x299a;"
        end

        def to_omml_without_math_tag(_)
          "&#x299a;"
        end

        def to_html
          "&#x299a;"
        end
      end
    end
  end
end
