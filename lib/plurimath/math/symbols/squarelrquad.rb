module Plurimath
  module Math
    module Symbols
      class Squarelrquad < Symbol
        INPUT = {
          unicodemath: [["&#x25f2;"], parsing_wrapper(["squarelrquad"])],
          asciimath: [["&#x25f2;"], parsing_wrapper(["squarelrquad"])],
          mathml: ["&#x25f2;"],
          latex: [["squarelrquad", "&#x25f2;"]],
          omml: ["&#x25f2;"],
          html: ["&#x25f2;"],
        }.freeze

        # output methods
        def to_latex
          "\\squarelrquad"
        end

        def to_asciimath
          parsing_wrapper("squarelrquad")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x25f2;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x25f2;"
        end

        def to_omml_without_math_tag(_)
          "&#x25f2;"
        end

        def to_html
          "&#x25f2;"
        end
      end
    end
  end
end
