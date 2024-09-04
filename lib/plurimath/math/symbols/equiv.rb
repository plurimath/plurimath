module Plurimath
  module Math
    module Symbols
      class Equiv < Symbol
        INPUT = {
          unicodemath: [["equiv", "&#x2261;"], parsing_wrapper(["-="], lang: :unicode)],
          asciimath: [["equiv", "-=", "&#x2261;"]],
          mathml: ["&#x2261;"],
          latex: [["equiv", "&#x2261;"], parsing_wrapper(["-="], lang: :latex)],
          omml: ["&#x2261;"],
          html: ["&#x2261;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\equiv"
        end

        def to_asciimath(**)
          "equiv"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2261;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2261;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2261;"
        end

        def to_html(**)
          "&#x2261;"
        end
      end
    end
  end
end
