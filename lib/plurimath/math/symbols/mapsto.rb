module Plurimath
  module Math
    module Symbols
      class Mapsto < Symbol
        INPUT = {
          unicodemath: [["mapsto", "&#x21a6;"], parsing_wrapper(["|->"], lang: :unicode)],
          asciimath: [["mapsto", "|->", "&#x21a6;"]],
          mathml: ["&#x21a6;"],
          latex: [["mapsto", "&#x21a6;"], parsing_wrapper(["|->"], lang: :latex)],
          omml: ["&#x21a6;"],
          html: ["&#x21a6;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\mapsto"
        end

        def to_asciimath(**)
          "mapsto"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x21a6;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x21a6;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x21a6;"
        end

        def to_html(**)
          "&#x21a6;"
        end
      end
    end
  end
end
