module Plurimath
  module Math
    module Symbols
      class Diceiv < Symbol
        INPUT = {
          unicodemath: [["&#x2683;"], parsing_wrapper(["diceiv"])],
          asciimath: [["&#x2683;"], parsing_wrapper(["diceiv"])],
          mathml: ["&#x2683;"],
          latex: [["diceiv", "&#x2683;"]],
          omml: ["&#x2683;"],
          html: ["&#x2683;"],
        }.freeze

        # output methods
        def to_latex
          "\\diceiv"
        end

        def to_asciimath
          parsing_wrapper("diceiv")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2683;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x2683;"
        end

        def to_omml_without_math_tag(_)
          "&#x2683;"
        end

        def to_html
          "&#x2683;"
        end
      end
    end
  end
end
