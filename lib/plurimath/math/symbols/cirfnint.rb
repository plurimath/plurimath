module Plurimath
  module Math
    module Symbols
      class Cirfnint < Symbol
        INPUT = {
          unicodemath: [["&#x2a10;"], parsing_wrapper(["cirfnint"], lang: :unicode)],
          asciimath: [["&#x2a10;"], parsing_wrapper(["cirfnint"], lang: :asciimath)],
          mathml: ["&#x2a10;"],
          latex: [["cirfnint", "&#x2a10;"]],
          omml: ["&#x2a10;"],
          html: ["&#x2a10;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\cirfnint"
        end

        def to_asciimath(**)
          parsing_wrapper("cirfnint", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a10;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a10;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a10;"
        end

        def to_html(**)
          "&#x2a10;"
        end
      end
    end
  end
end
