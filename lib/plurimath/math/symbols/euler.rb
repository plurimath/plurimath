module Plurimath
  module Math
    module Symbols
      class Euler < Symbol
        INPUT = {
          unicodemath: [["&#x2107;"], parsing_wrapper(["Eulerconst", "Euler"], lang: :unicode)],
          asciimath: [["&#x2107;"], parsing_wrapper(["Eulerconst", "Euler"], lang: :asciimath)],
          mathml: ["&#x2107;"],
          latex: [["Eulerconst", "Euler", "&#x2107;"]],
          omml: ["&#x2107;"],
          html: ["&#x2107;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\Eulerconst"
        end

        def to_asciimath(**)
          parsing_wrapper("Euler", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2107;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2107;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2107;"
        end

        def to_html(**)
          "&#x2107;"
        end
      end
    end
  end
end
