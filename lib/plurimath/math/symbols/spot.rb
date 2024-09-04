module Plurimath
  module Math
    module Symbols
      class Spot < Symbol
        INPUT = {
          unicodemath: [["&#x2981;"], parsing_wrapper(["mdsmblkcircle", "spot"], lang: :unicode)],
          asciimath: [["&#x2981;"], parsing_wrapper(["mdsmblkcircle", "spot"], lang: :asciimath)],
          mathml: ["&#x2981;"],
          latex: [["mdsmblkcircle", "spot", "&#x2981;"]],
          omml: ["&#x2981;"],
          html: ["&#x2981;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\mdsmblkcircle"
        end

        def to_asciimath(**)
          parsing_wrapper("spot", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2981;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2981;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2981;"
        end

        def to_html(**)
          "&#x2981;"
        end
      end
    end
  end
end
