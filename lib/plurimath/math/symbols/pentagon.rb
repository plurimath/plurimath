module Plurimath
  module Math
    module Symbols
      class Pentagon < Symbol
        INPUT = {
          unicodemath: [["&#x2b20;"], parsing_wrapper(["pentagon"])],
          asciimath: [["&#x2b20;"], parsing_wrapper(["pentagon"])],
          mathml: ["&#x2b20;"],
          latex: [["pentagon", "&#x2b20;"]],
          omml: ["&#x2b20;"],
          html: ["&#x2b20;"],
        }.freeze

        # output methods
        def to_latex
          "\\pentagon"
        end

        def to_asciimath
          parsing_wrapper("pentagon")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2b20;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x2b20;"
        end

        def to_omml_without_math_tag(_)
          "&#x2b20;"
        end

        def to_html
          "&#x2b20;"
        end
      end
    end
  end
end
