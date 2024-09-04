module Plurimath
  module Math
    module Symbols
      class Leftdownvectorbar < Symbol
        INPUT = {
          unicodemath: [["&#x2959;"], parsing_wrapper(["downharpoonleftbar", "LeftDownVectorBar"], lang: :unicode)],
          asciimath: [["&#x2959;"], parsing_wrapper(["downharpoonleftbar", "LeftDownVectorBar"], lang: :asciimath)],
          mathml: ["&#x2959;"],
          latex: [["downharpoonleftbar", "LeftDownVectorBar", "&#x2959;"]],
          omml: ["&#x2959;"],
          html: ["&#x2959;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\downharpoonleftbar"
        end

        def to_asciimath(**)
          parsing_wrapper("LeftDownVectorBar", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2959;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2959;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2959;"
        end

        def to_html(**)
          "&#x2959;"
        end
      end
    end
  end
end
