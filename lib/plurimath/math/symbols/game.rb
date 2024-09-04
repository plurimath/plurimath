module Plurimath
  module Math
    module Symbols
      class Game < Symbol
        INPUT = {
          unicodemath: [["&#x2141;"], parsing_wrapper(["Game"], lang: :unicode)],
          asciimath: [["&#x2141;"], parsing_wrapper(["Game"], lang: :asciimath)],
          mathml: ["&#x2141;"],
          latex: [["Game", "&#x2141;"]],
          omml: ["&#x2141;"],
          html: ["&#x2141;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\Game"
        end

        def to_asciimath(**)
          parsing_wrapper("Game", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2141;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2141;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2141;"
        end

        def to_html(**)
          "&#x2141;"
        end
      end
    end
  end
end
