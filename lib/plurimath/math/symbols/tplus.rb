module Plurimath
  module Math
    module Symbols
      class Tplus < Symbol
        INPUT = {
          unicodemath: [["&#x29fe;"], parsing_wrapper(["tplus"])],
          asciimath: [["&#x29fe;"], parsing_wrapper(["tplus"])],
          mathml: ["&#x29fe;"],
          latex: [["tplus", "&#x29fe;"]],
          omml: ["&#x29fe;"],
          html: ["&#x29fe;"],
        }.freeze

        # output methods
        def to_latex
          "\\tplus"
        end

        def to_asciimath
          parsing_wrapper("tplus")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x29fe;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x29fe;"
        end

        def to_omml_without_math_tag(_)
          "&#x29fe;"
        end

        def to_html
          "&#x29fe;"
        end
      end
    end
  end
end
