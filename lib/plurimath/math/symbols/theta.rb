module Plurimath
  module Math
    module Symbols
      class Theta < Symbol
        INPUT = {
          unicodemath: [["theta", "&#x3b8;"], parsing_wrapper(["uptheta"])],
          asciimath: [["theta", "&#x3b8;"], parsing_wrapper(["uptheta"])],
          mathml: ["&#x3b8;"],
          latex: [["uptheta", "theta", "&#x3b8;"]],
          omml: ["&#x3b8;"],
          html: ["&#x3b8;"],
        }.freeze

        # output methods
        def to_latex
          "\\theta"
        end

        def to_asciimath
          "theta"
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x3b8;")
        end

        def to_mathml_without_math_tag(_)
          ox_element("mi") << "&#x3b8;"
        end

        def to_omml_without_math_tag(_)
          "&#x3b8;"
        end

        def to_html
          "&#x3b8;"
        end
      end
    end
  end
end
