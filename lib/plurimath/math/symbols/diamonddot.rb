module Plurimath
  module Math
    module Symbols
      class Diamonddot < Symbol
        INPUT = {
          unicodemath: [["&#x27d0;"], parsing_wrapper(["diamondcdot", "Diamonddot"], lang: :unicode)],
          asciimath: [["&#x27d0;"], parsing_wrapper(["diamondcdot", "Diamonddot"], lang: :asciimath)],
          mathml: ["&#x27d0;"],
          latex: [["diamondcdot", "Diamonddot", "&#x27d0;"]],
          omml: ["&#x27d0;"],
          html: ["&#x27d0;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\diamondcdot"
        end

        def to_asciimath(**)
          parsing_wrapper("Diamonddot", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x27d0;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x27d0;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x27d0;"
        end

        def to_html(**)
          "&#x27d0;"
        end
      end
    end
  end
end
