module Plurimath
  module Math
    module Symbols
      class Leftvectorbar < Symbol
        INPUT = {
          unicodemath: [["&#x2952;"], parsing_wrapper(["barleftharpoonup", "LeftVectorBar"], lang: :unicode)],
          asciimath: [["&#x2952;"], parsing_wrapper(["barleftharpoonup", "LeftVectorBar"], lang: :asciimath)],
          mathml: ["&#x2952;"],
          latex: [["barleftharpoonup", "LeftVectorBar", "&#x2952;"]],
          omml: ["&#x2952;"],
          html: ["&#x2952;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\barleftharpoonup"
        end

        def to_asciimath(**)
          parsing_wrapper("LeftVectorBar", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2952;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2952;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2952;"
        end

        def to_html(**)
          "&#x2952;"
        end
      end
    end
  end
end
