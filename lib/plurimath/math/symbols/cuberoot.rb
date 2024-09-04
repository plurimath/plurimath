module Plurimath
  module Math
    module Symbols
      class Cuberoot < Symbol
        INPUT = {
          unicodemath: [["&#x221b;"], parsing_wrapper(["cuberoot"], lang: :unicode)],
          asciimath: [["&#x221b;"], parsing_wrapper(["cuberoot"], lang: :asciimath)],
          mathml: ["&#x221b;"],
          latex: [["cuberoot", "&#x221b;"]],
          omml: ["&#x221b;"],
          html: ["&#x221b;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\cuberoot"
        end

        def to_asciimath(**)
          parsing_wrapper("cuberoot", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x221b;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x221b;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x221b;"
        end

        def to_html(**)
          "&#x221b;"
        end
      end
    end
  end
end
