module Plurimath
  module Math
    module Symbols
      class Pi < Symbol
        INPUT = {
          unicodemath: [["pi", "&#x3c0;"], parsing_wrapper(["uppi"])],
          asciimath: [["pi", "&#x3c0;"], parsing_wrapper(["uppi"])],
          mathml: [["&#x3c0;"]],
          latex: [["pi", "uppi", "&#x3c0;"]],
          omml: [["&#x3c0;"]],
          html: ["&#x3C0;"],
        }.freeze

        # output methods
        def to_latex
          "\\pi"
        end

        def to_asciimath
          "pi"
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x3c0;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x3c0;"
        end

        def to_omml_without_math_tag(_)
          "&#x3c0;"
        end

        def to_html
          "&#x3C0;"
        end
      end
    end
  end
end
