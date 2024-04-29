module Plurimath
  module Math
    module Symbols
      class Eparsl < Symbol
        INPUT = {
          unicodemath: [["&#x29e3;"], parsing_wrapper(["eparsl"])],
          asciimath: [["&#x29e3;"], parsing_wrapper(["eparsl"])],
          mathml: ["&#x29e3;"],
          latex: [["eparsl", "&#x29e3;"]],
          omml: ["&#x29e3;"],
          html: ["&#x29e3;"],
        }.freeze

        # output methods
        def to_latex
          "\\eparsl"
        end

        def to_asciimath
          parsing_wrapper("eparsl")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x29e3;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x29e3;"
        end

        def to_omml_without_math_tag(_)
          "&#x29e3;"
        end

        def to_html
          "&#x29e3;"
        end
      end
    end
  end
end
