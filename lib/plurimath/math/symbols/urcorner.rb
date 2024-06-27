module Plurimath
  module Math
    module Symbols
      class Urcorner < Symbol
        INPUT = {
          unicodemath: [["&#x231d;"], parsing_wrapper(["urcorner"])],
          asciimath: [["&#x231d;"], parsing_wrapper(["urcorner"])],
          mathml: ["&#x231d;"],
          latex: [["urcorner", "&#x231d;"]],
          omml: ["&#x231d;"],
          html: ["&#x231d;"],
        }.freeze

        # output methods
        def to_latex
          "\\urcorner"
        end

        def to_asciimath
          parsing_wrapper("urcorner")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x231d;")
        end

        def to_mathml_without_math_tag(_)
          ox_element("mi") << "&#x231d;"
        end

        def to_omml_without_math_tag(_)
          "&#x231d;"
        end

        def to_html
          "&#x231d;"
        end
      end
    end
  end
end
