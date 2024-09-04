module Plurimath
  module Math
    module Symbols
      class Diceii < Symbol
        INPUT = {
          unicodemath: [["&#x2681;"], parsing_wrapper(["diceii"], lang: :unicode)],
          asciimath: [["&#x2681;"], parsing_wrapper(["diceii"], lang: :asciimath)],
          mathml: ["&#x2681;"],
          latex: [["diceii", "&#x2681;"]],
          omml: ["&#x2681;"],
          html: ["&#x2681;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\diceii"
        end

        def to_asciimath(**)
          parsing_wrapper("diceii", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2681;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2681;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2681;"
        end

        def to_html(**)
          "&#x2681;"
        end
      end
    end
  end
end
