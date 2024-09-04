module Plurimath
  module Math
    module Symbols
      class Measanglelutonw < Symbol
        INPUT = {
          unicodemath: [["&#x29a9;"], parsing_wrapper(["measanglelutonw"], lang: :unicode)],
          asciimath: [["&#x29a9;"], parsing_wrapper(["measanglelutonw"], lang: :asciimath)],
          mathml: ["&#x29a9;"],
          latex: [["measanglelutonw", "&#x29a9;"]],
          omml: ["&#x29a9;"],
          html: ["&#x29a9;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\measanglelutonw"
        end

        def to_asciimath(**)
          parsing_wrapper("measanglelutonw", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x29a9;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x29a9;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x29a9;"
        end

        def to_html(**)
          "&#x29a9;"
        end
      end
    end
  end
end
