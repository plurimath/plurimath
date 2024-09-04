module Plurimath
  module Math
    module Symbols
      class Leqslant < Symbol
        INPUT = {
          unicodemath: [["&#x2a7d;"], parsing_wrapper(["leqslant"], lang: :unicode)],
          asciimath: [["&#x2a7d;"], parsing_wrapper(["leqslant"], lang: :asciimath)],
          mathml: ["&#x2a7d;"],
          latex: [["leqslant", "&#x2a7d;"]],
          omml: ["&#x2a7d;"],
          html: ["&#x2a7d;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\leqslant"
        end

        def to_asciimath(**)
          parsing_wrapper("leqslant", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a7d;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a7d;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a7d;"
        end

        def to_html(**)
          "&#x2a7d;"
        end
      end
    end
  end
end
