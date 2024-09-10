module Plurimath
  module Math
    module Symbols
      class Twoheaduparrow < Symbol
        INPUT = {
          unicodemath: [["&#x219f;"], parsing_wrapper(["twoheaduparrow"], lang: :unicode)],
          asciimath: [["&#x219f;"], parsing_wrapper(["twoheaduparrow"], lang: :asciimath)],
          mathml: ["&#x219f;"],
          latex: [["twoheaduparrow", "&#x219f;"]],
          omml: ["&#x219f;"],
          html: ["&#x219f;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\twoheaduparrow"
        end

        def to_asciimath(**)
          parsing_wrapper("twoheaduparrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x219f;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x219f;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x219f;"
        end

        def to_html(**)
          "&#x219f;"
        end
      end
    end
  end
end
