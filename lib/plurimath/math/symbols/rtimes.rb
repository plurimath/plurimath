module Plurimath
  module Math
    module Symbols
      class Rtimes < Symbol
        INPUT = {
          unicodemath: [["rtimes", "&#x22ca;"], parsing_wrapper(["><|"], lang: :unicode)],
          asciimath: [["rtimes", "><|", "&#x22ca;"]],
          mathml: ["&#x22ca;"],
          latex: [["rtimes", "&#x22ca;"], parsing_wrapper(["><|"], lang: :latex)],
          omml: ["&#x22ca;"],
          html: ["&#x22ca;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\rtimes"
        end

        def to_asciimath(**)
          "rtimes"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22ca;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22ca;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22ca;"
        end

        def to_html(**)
          "&#x22ca;"
        end
      end
    end
  end
end
