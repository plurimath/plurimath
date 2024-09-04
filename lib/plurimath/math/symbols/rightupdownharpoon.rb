module Plurimath
  module Math
    module Symbols
      class Rightupdownharpoon < Symbol
        INPUT = {
          unicodemath: [["&#x294f;"], parsing_wrapper(["updownharpoonrightright", "rightupdownharpoon"], lang: :unicode)],
          asciimath: [["&#x294f;"], parsing_wrapper(["updownharpoonrightright", "rightupdownharpoon"], lang: :asciimath)],
          mathml: ["&#x294f;"],
          latex: [["updownharpoonrightright", "rightupdownharpoon", "&#x294f;"]],
          omml: ["&#x294f;"],
          html: ["&#x294f;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\updownharpoonrightright"
        end

        def to_asciimath(**)
          parsing_wrapper("rightupdownharpoon", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x294f;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x294f;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x294f;"
        end

        def to_html(**)
          "&#x294f;"
        end
      end
    end
  end
end
