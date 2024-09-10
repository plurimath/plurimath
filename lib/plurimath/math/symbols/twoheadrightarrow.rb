module Plurimath
  module Math
    module Symbols
      class Twoheadrightarrow < Symbol
        INPUT = {
          unicodemath: [["twoheadrightarrow", "&#x21a0;"], parsing_wrapper(["->>", "tsur"], lang: :unicode)],
          asciimath: [["twoheadrightarrow", "->>", "&#x21a0;"], parsing_wrapper(["tsur"], lang: :asciimath)],
          mathml: ["&#x21a0;"],
          latex: [["twoheadrightarrow", "tsur", "&#x21a0;"], parsing_wrapper(["->>"], lang: :latex)],
          omml: ["&#x21a0;"],
          html: ["&#x21a0;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\twoheadrightarrow"
        end

        def to_asciimath(**)
          "twoheadrightarrow"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x21a0;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x21a0;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x21a0;"
        end

        def to_html(**)
          "&#x21a0;"
        end
      end
    end
  end
end
