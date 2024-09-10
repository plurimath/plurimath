module Plurimath
  module Math
    module Symbols
      class Twoheadmapsto < Symbol
        INPUT = {
          unicodemath: [["&#x2905;"], parsing_wrapper(["twoheadmapsto"], lang: :unicode)],
          asciimath: [["&#x2905;"], parsing_wrapper(["twoheadmapsto"], lang: :asciimath)],
          mathml: ["&#x2905;"],
          latex: [["twoheadmapsto", "&#x2905;"]],
          omml: ["&#x2905;"],
          html: ["&#x2905;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\twoheadmapsto"
        end

        def to_asciimath(**)
          parsing_wrapper("twoheadmapsto", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2905;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2905;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2905;"
        end

        def to_html(**)
          "&#x2905;"
        end
      end
    end
  end
end
