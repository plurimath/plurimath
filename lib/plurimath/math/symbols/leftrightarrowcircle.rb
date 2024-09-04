module Plurimath
  module Math
    module Symbols
      class Leftrightarrowcircle < Symbol
        INPUT = {
          unicodemath: [["&#x2948;"], parsing_wrapper(["leftrightarrowcircle"], lang: :unicode)],
          asciimath: [["&#x2948;"], parsing_wrapper(["leftrightarrowcircle"], lang: :asciimath)],
          mathml: ["&#x2948;"],
          latex: [["leftrightarrowcircle", "&#x2948;"]],
          omml: ["&#x2948;"],
          html: ["&#x2948;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\leftrightarrowcircle"
        end

        def to_asciimath(**)
          parsing_wrapper("leftrightarrowcircle", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2948;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2948;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2948;"
        end

        def to_html(**)
          "&#x2948;"
        end
      end
    end
  end
end
