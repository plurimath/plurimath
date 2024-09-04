module Plurimath
  module Math
    module Symbols
      class Lrcorner < Symbol
        INPUT = {
          unicodemath: [["&#x231f;"], parsing_wrapper(["lrcorner"], lang: :unicode)],
          asciimath: [["&#x231f;"], parsing_wrapper(["lrcorner"], lang: :asciimath)],
          mathml: ["&#x231f;"],
          latex: [["lrcorner", "&#x231f;"]],
          omml: ["&#x231f;"],
          html: ["&#x231f;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\lrcorner"
        end

        def to_asciimath(**)
          parsing_wrapper("lrcorner", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x231f;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x231f;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x231f;"
        end

        def to_html(**)
          "&#x231f;"
        end
      end
    end
  end
end
