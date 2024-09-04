module Plurimath
  module Math
    module Symbols
      class Hexagonblack < Symbol
        INPUT = {
          unicodemath: [["&#x2b23;"], parsing_wrapper(["hexagonblack"], lang: :unicode)],
          asciimath: [["&#x2b23;"], parsing_wrapper(["hexagonblack"], lang: :asciimath)],
          mathml: ["&#x2b23;"],
          latex: [["hexagonblack", "&#x2b23;"]],
          omml: ["&#x2b23;"],
          html: ["&#x2b23;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\hexagonblack"
        end

        def to_asciimath(**)
          parsing_wrapper("hexagonblack", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2b23;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2b23;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2b23;"
        end

        def to_html(**)
          "&#x2b23;"
        end
      end
    end
  end
end
