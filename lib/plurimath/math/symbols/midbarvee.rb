module Plurimath
  module Math
    module Symbols
      class Midbarvee < Symbol
        INPUT = {
          unicodemath: [["&#x2a5d;"], parsing_wrapper(["midbarvee"], lang: :unicode)],
          asciimath: [["&#x2a5d;"], parsing_wrapper(["midbarvee"], lang: :asciimath)],
          mathml: ["&#x2a5d;"],
          latex: [["midbarvee", "&#x2a5d;"]],
          omml: ["&#x2a5d;"],
          html: ["&#x2a5d;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\midbarvee"
        end

        def to_asciimath(**)
          parsing_wrapper("midbarvee", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a5d;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a5d;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a5d;"
        end

        def to_html(**)
          "&#x2a5d;"
        end
      end
    end
  end
end
