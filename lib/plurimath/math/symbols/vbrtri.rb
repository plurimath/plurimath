module Plurimath
  module Math
    module Symbols
      class Vbrtri < Symbol
        INPUT = {
          unicodemath: [["&#x29d0;"], parsing_wrapper(["RightTriangleBar", "vbrtri"])],
          asciimath: [["&#x29d0;"], parsing_wrapper(["RightTriangleBar", "vbrtri"])],
          mathml: ["&#x29d0;"],
          latex: [["RightTriangleBar", "vbrtri", "&#x29d0;"]],
          omml: ["&#x29d0;"],
          html: ["&#x29d0;"],
        }.freeze

        # output methods
        def to_latex
          "\\RightTriangleBar"
        end

        def to_asciimath
          parsing_wrapper("vbrtri")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x29d0;")
        end

        def to_mathml_without_math_tag(_)
          ox_element("mi") << "&#x29d0;"
        end

        def to_omml_without_math_tag(_)
          "&#x29d0;"
        end

        def to_html
          "&#x29d0;"
        end
      end
    end
  end
end
