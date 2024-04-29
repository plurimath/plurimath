module Plurimath
  module Math
    module Symbols
      class Overbar < Symbol
        INPUT = {
          unicodemath: [["&#x305;"], parsing_wrapper(["overbar"])],
          asciimath: [["&#x305;"], parsing_wrapper(["overbar"])],
          mathml: ["&#x305;"],
          latex: [["overbar", "&#x305;"]],
          omml: ["&#x305;"],
          html: ["&#x305;"],
        }.freeze

        # output methods
        def to_latex
          "\\overbar"
        end

        def to_asciimath
          parsing_wrapper("overbar")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x305;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x305;"
        end

        def to_omml_without_math_tag(_)
          "&#x305;"
        end

        def to_html
          "&#x305;"
        end
      end
    end
  end
end
