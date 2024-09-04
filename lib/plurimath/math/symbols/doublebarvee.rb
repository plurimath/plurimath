module Plurimath
  module Math
    module Symbols
      class Doublebarvee < Symbol
        INPUT = {
          unicodemath: [["&#x2a62;"], parsing_wrapper(["doublebarvee"], lang: :unicode)],
          asciimath: [["&#x2a62;"], parsing_wrapper(["doublebarvee"], lang: :asciimath)],
          mathml: ["&#x2a62;"],
          latex: [["doublebarvee", "&#x2a62;"]],
          omml: ["&#x2a62;"],
          html: ["&#x2a62;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\doublebarvee"
        end

        def to_asciimath(**)
          parsing_wrapper("doublebarvee", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a62;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a62;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a62;"
        end

        def to_html(**)
          "&#x2a62;"
        end
      end
    end
  end
end
