module Plurimath
  module Math
    module Symbols
      class Minusrdots < Symbol
        INPUT = {
          unicodemath: [["&#x2a2c;"], parsing_wrapper(["minusrdots"], lang: :unicode)],
          asciimath: [["&#x2a2c;"], parsing_wrapper(["minusrdots"], lang: :asciimath)],
          mathml: ["&#x2a2c;"],
          latex: [["minusrdots", "&#x2a2c;"]],
          omml: ["&#x2a2c;"],
          html: ["&#x2a2c;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\minusrdots"
        end

        def to_asciimath(**)
          parsing_wrapper("minusrdots", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a2c;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a2c;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a2c;"
        end

        def to_html(**)
          "&#x2a2c;"
        end
      end
    end
  end
end
