module Plurimath
  module Math
    module Symbols
      class Degf < Symbol
        INPUT = {
          unicodemath: [["degf", "&#x2109;"]],
          asciimath: [["&#x2109;"], parsing_wrapper(["degf"], lang: :asciimath)],
          mathml: ["&#x2109;"],
          latex: [["&#x2109;"], parsing_wrapper(["degf"], lang: :latex)],
          omml: ["&#x2109;"],
          html: ["&#x2109;"],
        }.freeze

        # output methods
        def to_latex(**)
          parsing_wrapper("degf", lang: :latex)
        end

        def to_asciimath(**)
          parsing_wrapper("degf", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2109;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2109;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2109;"
        end

        def to_html(**)
          "&#x2109;"
        end
      end
    end
  end
end
