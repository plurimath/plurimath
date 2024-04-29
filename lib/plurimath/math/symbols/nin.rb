module Plurimath
  module Math
    module Symbols
      class Nin < Symbol
        INPUT = {
          unicodemath: [["notin", "&#x2209;"], parsing_wrapper(["!in", "nin"])],
          asciimath: [["notin", "!in", "&#x2209;"], parsing_wrapper(["nin"])],
          mathml: ["&#x2209;"],
          latex: [["notin", "nin", "&#x2209;"], parsing_wrapper(["!in"])],
          omml: ["&#x2209;"],
          html: ["&#x2209;"],
        }.freeze

        # output methods
        def to_latex
          "\\notin"
        end

        def to_asciimath
          parsing_wrapper("nin")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2209;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x2209;"
        end

        def to_omml_without_math_tag(_)
          "&#x2209;"
        end

        def to_html
          "&#x2209;"
        end
      end
    end
  end
end
