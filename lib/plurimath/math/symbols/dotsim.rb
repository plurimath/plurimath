module Plurimath
  module Math
    module Symbols
      class Dotsim < Symbol
        INPUT = {
          unicodemath: [["&#x2a6a;"], parsing_wrapper(["dotsim"], lang: :unicode)],
          asciimath: [["&#x2a6a;"], parsing_wrapper(["dotsim"], lang: :asciimath)],
          mathml: ["&#x2a6a;"],
          latex: [["dotsim", "&#x2a6a;"]],
          omml: ["&#x2a6a;"],
          html: ["&#x2a6a;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\dotsim"
        end

        def to_asciimath(**)
          parsing_wrapper("dotsim", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a6a;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a6a;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a6a;"
        end

        def to_html(**)
          "&#x2a6a;"
        end
      end
    end
  end
end
