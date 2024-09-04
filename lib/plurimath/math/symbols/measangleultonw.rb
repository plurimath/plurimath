module Plurimath
  module Math
    module Symbols
      class Measangleultonw < Symbol
        INPUT = {
          unicodemath: [["&#x29ad;"], parsing_wrapper(["measangleultonw"], lang: :unicode)],
          asciimath: [["&#x29ad;"], parsing_wrapper(["measangleultonw"], lang: :asciimath)],
          mathml: ["&#x29ad;"],
          latex: [["measangleultonw", "&#x29ad;"]],
          omml: ["&#x29ad;"],
          html: ["&#x29ad;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\measangleultonw"
        end

        def to_asciimath(**)
          parsing_wrapper("measangleultonw", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x29ad;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x29ad;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x29ad;"
        end

        def to_html(**)
          "&#x29ad;"
        end
      end
    end
  end
end
