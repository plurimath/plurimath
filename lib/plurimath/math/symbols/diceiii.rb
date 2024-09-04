module Plurimath
  module Math
    module Symbols
      class Diceiii < Symbol
        INPUT = {
          unicodemath: [["&#x2682;"], parsing_wrapper(["diceiii"], lang: :unicode)],
          asciimath: [["&#x2682;"], parsing_wrapper(["diceiii"], lang: :asciimath)],
          mathml: ["&#x2682;"],
          latex: [["diceiii", "&#x2682;"]],
          omml: ["&#x2682;"],
          html: ["&#x2682;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\diceiii"
        end

        def to_asciimath(**)
          parsing_wrapper("diceiii", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2682;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2682;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2682;"
        end

        def to_html(**)
          "&#x2682;"
        end
      end
    end
  end
end
