module Plurimath
  module Math
    module Symbols
      class Triangles < Symbol
        INPUT = {
          unicodemath: [["&#x29cc;"], parsing_wrapper(["triangles"])],
          asciimath: [["&#x29cc;"], parsing_wrapper(["triangles"])],
          mathml: ["&#x29cc;"],
          latex: [["triangles", "&#x29cc;"]],
          omml: ["&#x29cc;"],
          html: ["&#x29cc;"],
        }.freeze

        # output methods
        def to_latex
          "\\triangles"
        end

        def to_asciimath
          parsing_wrapper("triangles")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x29cc;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x29cc;"
        end

        def to_omml_without_math_tag(_)
          "&#x29cc;"
        end

        def to_html
          "&#x29cc;"
        end
      end
    end
  end
end
