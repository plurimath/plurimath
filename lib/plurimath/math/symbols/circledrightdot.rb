module Plurimath
  module Math
    module Symbols
      class Circledrightdot < Symbol
        INPUT = {
          unicodemath: [["&#x2686;"], parsing_wrapper(["circledrightdot"], lang: :unicode)],
          asciimath: [["&#x2686;"], parsing_wrapper(["circledrightdot"], lang: :asciimath)],
          mathml: ["&#x2686;"],
          latex: [["circledrightdot", "&#x2686;"]],
          omml: ["&#x2686;"],
          html: ["&#x2686;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\circledrightdot"
        end

        def to_asciimath(**)
          parsing_wrapper("circledrightdot", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2686;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2686;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2686;"
        end

        def to_html(**)
          "&#x2686;"
        end
      end
    end
  end
end
