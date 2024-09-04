module Plurimath
  module Math
    module Symbols
      class Rparenextender < Symbol
        INPUT = {
          unicodemath: [["&#x239f;"], parsing_wrapper(["rparenextender"], lang: :unicode)],
          asciimath: [["&#x239f;"], parsing_wrapper(["rparenextender"], lang: :asciimath)],
          mathml: ["&#x239f;"],
          latex: [["rparenextender", "&#x239f;"]],
          omml: ["&#x239f;"],
          html: ["&#x239f;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\rparenextender"
        end

        def to_asciimath(**)
          parsing_wrapper("rparenextender", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x239f;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x239f;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x239f;"
        end

        def to_html(**)
          "&#x239f;"
        end
      end
    end
  end
end
