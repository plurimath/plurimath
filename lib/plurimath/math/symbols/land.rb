module Plurimath
  module Math
    module Symbols
      class Land < Symbol
        INPUT = {
          unicodemath: [["wedge", "&#x2227;"], parsing_wrapper(["^^", "land"])],
          asciimath: [["wedge", "^^", "&#x2227;"], parsing_wrapper(["land"])],
          mathml: ["&#x2227;"],
          latex: [["wedge", "land", "&#x2227;"], parsing_wrapper(["^^"])],
          omml: ["&#x2227;"],
          html: ["&#x2227;"],
        }.freeze

        # output methods
        def to_latex
          "\\land"
        end

        def to_asciimath
          "^^"
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2227;")
        end

        def to_mathml_without_math_tag(_)
          ox_element("mo") << "&#x2227;"
        end

        def to_omml_without_math_tag(_)
          "&#x2227;"
        end

        def to_html
          "&#x2227;"
        end
      end
    end
  end
end
