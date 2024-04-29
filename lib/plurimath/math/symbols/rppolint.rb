module Plurimath
  module Math
    module Symbols
      class Rppolint < Symbol
        INPUT = {
          unicodemath: [["&#x2a12;"], parsing_wrapper(["rppolint"])],
          asciimath: [["&#x2a12;"], parsing_wrapper(["rppolint"])],
          mathml: ["&#x2a12;"],
          latex: [["rppolint", "&#x2a12;"]],
          omml: ["&#x2a12;"],
          html: ["&#x2a12;"],
        }.freeze

        # output methods
        def to_latex
          "\\rppolint"
        end

        def to_asciimath
          parsing_wrapper("rppolint")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2a12;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x2a12;"
        end

        def to_omml_without_math_tag(_)
          "&#x2a12;"
        end

        def to_html
          "&#x2a12;"
        end
      end
    end
  end
end
