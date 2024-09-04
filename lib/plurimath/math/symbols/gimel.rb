module Plurimath
  module Math
    module Symbols
      class Gimel < Symbol
        INPUT = {
          unicodemath: [["gimel", "&#x2137;"]],
          asciimath: [["&#x2137;"], parsing_wrapper(["gimel"], lang: :asciimath)],
          mathml: ["&#x2137;"],
          latex: [["gimel", "&#x2137;"]],
          omml: ["&#x2137;"],
          html: ["&#x2137;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\gimel"
        end

        def to_asciimath(**)
          parsing_wrapper("gimel", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2137;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2137;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2137;"
        end

        def to_html(**)
          "&#x2137;"
        end
      end
    end
  end
end
