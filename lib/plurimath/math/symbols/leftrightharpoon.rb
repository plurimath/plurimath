module Plurimath
  module Math
    module Symbols
      class Leftrightharpoon < Symbol
        INPUT = {
          unicodemath: [["&#x294a;"], parsing_wrapper(["leftrightharpoonupdown", "leftrightharpoon"], lang: :unicode)],
          asciimath: [["&#x294a;"], parsing_wrapper(["leftrightharpoonupdown", "leftrightharpoon"], lang: :asciimath)],
          mathml: ["&#x294a;"],
          latex: [["leftrightharpoonupdown", "leftrightharpoon", "&#x294a;"]],
          omml: ["&#x294a;"],
          html: ["&#x294a;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\leftrightharpoonupdown"
        end

        def to_asciimath(**)
          parsing_wrapper("leftrightharpoon", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x294a;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x294a;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x294a;"
        end

        def to_html(**)
          "&#x294a;"
        end
      end
    end
  end
end
