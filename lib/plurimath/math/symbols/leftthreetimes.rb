module Plurimath
  module Math
    module Symbols
      class Leftthreetimes < Symbol
        INPUT = {
          unicodemath: [["leftthreetimes", "&#x22cb;"]],
          asciimath: [["&#x22cb;"], parsing_wrapper(["leftthreetimes"])],
          mathml: ["&#x22cb;"],
          latex: [["leftthreetimes", "&#x22cb;"]],
          omml: ["&#x22cb;"],
          html: ["&#x22cb;"],
        }.freeze

        # output methods
        def to_latex
          "\\leftthreetimes"
        end

        def to_asciimath
          parsing_wrapper("leftthreetimes")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x22cb;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x22cb;"
        end

        def to_omml_without_math_tag(_)
          "&#x22cb;"
        end

        def to_html
          "&#x22cb;"
        end
      end
    end
  end
end
