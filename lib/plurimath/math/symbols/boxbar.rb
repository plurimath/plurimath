module Plurimath
  module Math
    module Symbols
      class Boxbar < Symbol
        INPUT = {
          unicodemath: [["&#x25eb;"], parsing_wrapper(["boxbar"])],
          asciimath: [["&#x25eb;"], parsing_wrapper(["boxbar"])],
          mathml: ["&#x25eb;"],
          latex: [["boxbar", "&#x25eb;"]],
          omml: ["&#x25eb;"],
          html: ["&#x25eb;"],
        }.freeze

        # output methods
        def to_latex
          "\\boxbar"
        end

        def to_asciimath
          parsing_wrapper("boxbar")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x25eb;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x25eb;"
        end

        def to_omml_without_math_tag(_)
          "&#x25eb;"
        end

        def to_html
          "&#x25eb;"
        end
      end
    end
  end
end
