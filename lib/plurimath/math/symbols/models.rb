module Plurimath
  module Math
    module Symbols
      class Models < Symbol
        INPUT = {
          unicodemath: [["models", "&#x22a8;"], parsing_wrapper(["|==", "vDash"])],
          asciimath: [["models", "|==", "&#x22a8;"], parsing_wrapper(["vDash"])],
          mathml: ["&#x22a8;"],
          latex: [["vDash", "&#x22a8;"], parsing_wrapper(["models", "|=="])],
          omml: ["&#x22a8;"],
          html: ["&#x22a8;"],
        }.freeze

        # output methods
        def to_latex
          "\\vDash"
        end

        def to_asciimath
          "models"
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x22a8;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x22a8;"
        end

        def to_omml_without_math_tag(_)
          "&#x22a8;"
        end

        def to_html
          "&#x22a8;"
        end
      end
    end
  end
end
