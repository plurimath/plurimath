module Plurimath
  module Math
    module Symbols
      class Rightdownvectorbar < Symbol
        INPUT = {
          unicodemath: [["&#x2955;"], parsing_wrapper(["downharpoonrightbar", "RightDownVectorBar"], lang: :unicode)],
          asciimath: [["&#x2955;"], parsing_wrapper(["downharpoonrightbar", "RightDownVectorBar"], lang: :asciimath)],
          mathml: ["&#x2955;"],
          latex: [["downharpoonrightbar", "RightDownVectorBar", "&#x2955;"]],
          omml: ["&#x2955;"],
          html: ["&#x2955;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\downharpoonrightbar"
        end

        def to_asciimath(**)
          parsing_wrapper("RightDownVectorBar", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2955;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2955;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2955;"
        end

        def to_html(**)
          "&#x2955;"
        end
      end
    end
  end
end
