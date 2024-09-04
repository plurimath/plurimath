module Plurimath
  module Math
    module Symbols
      class Uranus < Symbol
        INPUT = {
          unicodemath: [["&#x2645;"], parsing_wrapper(["uranus", "Uranus"], lang: :unicode)],
          asciimath: [["&#x2645;"], parsing_wrapper(["uranus", "Uranus"], lang: :asciimath)],
          mathml: ["&#x2645;"],
          latex: [["uranus", "Uranus", "&#x2645;"]],
          omml: ["&#x2645;"],
          html: ["&#x2645;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\uranus"
        end

        def to_asciimath(**)
          parsing_wrapper("Uranus", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2645;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2645;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2645;"
        end

        def to_html(**)
          "&#x2645;"
        end
      end
    end
  end
end
