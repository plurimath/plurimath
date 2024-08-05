module Plurimath
  module Math
    module Symbols
      class Ll < Symbol
        INPUT = {
          unicodemath: [["ll", "&#x226a;"]],
          asciimath: [["&#x226a;"], parsing_wrapper(["ll"], lang: :asciimath)],
          mathml: ["&#x226a;"],
          latex: [["ll", "&#x226a;"]],
          omml: ["&#x226a;"],
          html: ["&#x226a;"],
        }.freeze

        # output methods
        def to_latex
          "\\ll"
        end

        def to_asciimath
          parsing_wrapper("ll", lang: :asciimath)
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x226a;")
        end

        def to_mathml_without_math_tag(_)
          ox_element("mi") << "&#x226a;"
        end

        def to_omml_without_math_tag(_)
          "&#x226a;"
        end

        def to_html
          "&#x226a;"
        end
      end
    end
  end
end
