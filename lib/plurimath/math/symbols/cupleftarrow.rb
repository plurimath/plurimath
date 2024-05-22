module Plurimath
  module Math
    module Symbols
      class Cupleftarrow < Symbol
        INPUT = {
          unicodemath: [["&#x228c;"], parsing_wrapper(["cupleftarrow"])],
          asciimath: [["&#x228c;"], parsing_wrapper(["cupleftarrow"])],
          mathml: ["&#x228c;"],
          latex: [["cupleftarrow", "&#x228c;"]],
          omml: ["&#x228c;"],
          html: ["&#x228c;"],
        }.freeze

        # output methods
        def to_latex
          "\\cupleftarrow"
        end

        def to_asciimath
          parsing_wrapper("cupleftarrow")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x228c;")
        end

        def to_mathml_without_math_tag(_)
          ox_element("mi") << "&#x228c;"
        end

        def to_omml_without_math_tag(_)
          "&#x228c;"
        end

        def to_html
          "&#x228c;"
        end
      end
    end
  end
end
