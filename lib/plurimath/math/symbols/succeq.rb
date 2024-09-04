module Plurimath
  module Math
    module Symbols
      class Succeq < Symbol
        INPUT = {
          unicodemath: [["succeq", "&#x2ab0;"], parsing_wrapper([">-="], lang: :unicode)],
          asciimath: [["succeq", ">-=", "&#x2ab0;"]],
          mathml: ["&#x2ab0;"],
          latex: [["succeq", "&#x2ab0;"], parsing_wrapper([">-="], lang: :latex)],
          omml: ["&#x2ab0;"],
          html: ["&#x2ab0;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\succeq"
        end

        def to_asciimath(**)
          "succeq"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2ab0;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2ab0;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2ab0;"
        end

        def to_html(**)
          "&#x2ab0;"
        end
      end
    end
  end
end
