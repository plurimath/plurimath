module Plurimath
  module Math
    module Symbols
      class Nunlhd < Symbol
        INPUT = {
          unicodemath: [["&#x22ec;"], parsing_wrapper(["ntrianglelefteq", "nunlhd"], lang: :unicode)],
          asciimath: [["&#x22ec;"], parsing_wrapper(["ntrianglelefteq", "nunlhd"], lang: :asciimath)],
          mathml: ["&#x22ec;"],
          latex: [["ntrianglelefteq", "nunlhd", "&#x22ec;"]],
          omml: ["&#x22ec;"],
          html: ["&#x22ec;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\ntrianglelefteq"
        end

        def to_asciimath(**)
          parsing_wrapper("nunlhd", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22ec;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22ec;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22ec;"
        end

        def to_html(**)
          "&#x22ec;"
        end
      end
    end
  end
end
