module Plurimath
  module Math
    module Symbols
      class Leftrightarrowtriangle < Symbol
        INPUT = {
          unicodemath: [["&#x21ff;"], parsing_wrapper(["leftrightarrowtriangle"], lang: :unicode)],
          asciimath: [["&#x21ff;"], parsing_wrapper(["leftrightarrowtriangle"], lang: :asciimath)],
          mathml: ["&#x21ff;"],
          latex: [["leftrightarrowtriangle", "&#x21ff;"]],
          omml: ["&#x21ff;"],
          html: ["&#x21ff;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\leftrightarrowtriangle"
        end

        def to_asciimath(**)
          parsing_wrapper("leftrightarrowtriangle", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x21ff;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x21ff;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x21ff;"
        end

        def to_html(**)
          "&#x21ff;"
        end
      end
    end
  end
end
