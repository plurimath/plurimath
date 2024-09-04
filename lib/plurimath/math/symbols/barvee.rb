module Plurimath
  module Math
    module Symbols
      class Barvee < Symbol
        INPUT = {
          unicodemath: [["&#x22bd;"], parsing_wrapper(["barvee"], lang: :unicode)],
          asciimath: [["&#x22bd;"], parsing_wrapper(["barvee"], lang: :asciimath)],
          mathml: ["&#x22bd;"],
          latex: [["barvee", "&#x22bd;"]],
          omml: ["&#x22bd;"],
          html: ["&#x22bd;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\barvee"
        end

        def to_asciimath(**)
          parsing_wrapper("barvee", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22bd;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22bd;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22bd;"
        end

        def to_html(**)
          "&#x22bd;"
        end
      end
    end
  end
end
