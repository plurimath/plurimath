module Plurimath
  module Math
    module Symbols
      class Hexagon < Symbol
        INPUT = {
          unicodemath: [["&#x2394;"], parsing_wrapper(["hexagon"], lang: :unicode)],
          asciimath: [["&#x2394;"], parsing_wrapper(["hexagon"], lang: :asciimath)],
          mathml: ["&#x2394;"],
          latex: [["hexagon", "&#x2394;"]],
          omml: ["&#x2394;"],
          html: ["&#x2394;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\hexagon"
        end

        def to_asciimath(**)
          parsing_wrapper("hexagon", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2394;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2394;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2394;"
        end

        def to_html(**)
          "&#x2394;"
        end
      end
    end
  end
end
