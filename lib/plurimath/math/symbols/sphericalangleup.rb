module Plurimath
  module Math
    module Symbols
      class Sphericalangleup < Symbol
        INPUT = {
          unicodemath: [["&#x29a1;"], parsing_wrapper(["sphericalangleup"])],
          asciimath: [["&#x29a1;"], parsing_wrapper(["sphericalangleup"])],
          mathml: ["&#x29a1;"],
          latex: [["sphericalangleup", "&#x29a1;"]],
          omml: ["&#x29a1;"],
          html: ["&#x29a1;"],
        }.freeze

        # output methods
        def to_latex
          "\\sphericalangleup"
        end

        def to_asciimath
          parsing_wrapper("sphericalangleup")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x29a1;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x29a1;"
        end

        def to_omml_without_math_tag(_)
          "&#x29a1;"
        end

        def to_html
          "&#x29a1;"
        end
      end
    end
  end
end
