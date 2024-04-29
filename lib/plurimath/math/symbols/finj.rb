module Plurimath
  module Math
    module Symbols
      class Finj < Symbol
        INPUT = {
          unicodemath: [["&#x2915;"], parsing_wrapper(["nVrightarrowtail", "finj"])],
          asciimath: [["&#x2915;"], parsing_wrapper(["nVrightarrowtail", "finj"])],
          mathml: ["&#x2915;"],
          latex: [["nVrightarrowtail", "finj", "&#x2915;"]],
          omml: ["&#x2915;"],
          html: ["&#x2915;"],
        }.freeze

        # output methods
        def to_latex
          "\\nVrightarrowtail"
        end

        def to_asciimath
          parsing_wrapper("finj")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2915;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x2915;"
        end

        def to_omml_without_math_tag(_)
          "&#x2915;"
        end

        def to_html
          "&#x2915;"
        end
      end
    end
  end
end
