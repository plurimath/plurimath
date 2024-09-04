module Plurimath
  module Math
    module Symbols
      class Prec < Symbol
        INPUT = {
          unicodemath: [["prec", "&#x227a;"], parsing_wrapper(["-<"], lang: :unicode)],
          asciimath: [["prec", "-<", "&#x227a;"]],
          mathml: ["&#x227a;"],
          latex: [["prec", "&#x227a;"], parsing_wrapper(["-<"], lang: :latex)],
          omml: ["&#x227a;"],
          html: ["&#x227a;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\prec"
        end

        def to_asciimath(**)
          "prec"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x227a;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x227a;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x227a;"
        end

        def to_html(**)
          "&#x227a;"
        end
      end
    end
  end
end
