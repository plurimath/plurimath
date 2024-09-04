module Plurimath
  module Math
    module Symbols
      class Eqcolon < Symbol
        INPUT = {
          unicodemath: [["&#x2239;"], parsing_wrapper(["dashcolon", "eqcolon"], lang: :unicode)],
          asciimath: [["&#x2239;"], parsing_wrapper(["dashcolon", "eqcolon"], lang: :asciimath)],
          mathml: ["&#x2239;"],
          latex: [["dashcolon", "eqcolon", "&#x2239;"]],
          omml: ["&#x2239;"],
          html: ["&#x2239;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\dashcolon"
        end

        def to_asciimath(**)
          parsing_wrapper("eqcolon", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2239;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2239;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2239;"
        end

        def to_html(**)
          "&#x2239;"
        end
      end
    end
  end
end
