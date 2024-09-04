module Plurimath
  module Math
    module Symbols
      class Rparen < Symbol
        INPUT = {
          unicodemath: [["&#x29;"], parsing_wrapper(["rparen"], lang: :unicode)],
          asciimath: [["&#x29;"], parsing_wrapper(["rparen"], lang: :asciimath)],
          mathml: ["&#x29;"],
          latex: [["rparen", "&#x29;"]],
          omml: ["&#x29;"],
          html: ["&#x29;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\rparen"
        end

        def to_asciimath(**)
          parsing_wrapper("rparen", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x29;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x29;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x29;"
        end

        def to_html(**)
          "&#x29;"
        end
      end
    end
  end
end
