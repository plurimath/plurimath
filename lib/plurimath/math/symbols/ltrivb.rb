module Plurimath
  module Math
    module Symbols
      class Ltrivb < Symbol
        INPUT = {
          unicodemath: [["&#x29cf;"], parsing_wrapper(["LeftTriangleBar", "ltrivb"], lang: :unicode)],
          asciimath: [["&#x29cf;"], parsing_wrapper(["LeftTriangleBar", "ltrivb"], lang: :asciimath)],
          mathml: ["&#x29cf;"],
          latex: [["LeftTriangleBar", "ltrivb", "&#x29cf;"]],
          omml: ["&#x29cf;"],
          html: ["&#x29cf;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\LeftTriangleBar"
        end

        def to_asciimath(**)
          parsing_wrapper("ltrivb", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x29cf;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x29cf;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x29cf;"
        end

        def to_html(**)
          "&#x29cf;"
        end
      end
    end
  end
end
