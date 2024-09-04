module Plurimath
  module Math
    module Symbols
      class Rightleftharpoon < Symbol
        INPUT = {
          unicodemath: [["&#x294b;"], parsing_wrapper(["leftrightharpoondownup", "rightleftharpoon"], lang: :unicode)],
          asciimath: [["&#x294b;"], parsing_wrapper(["leftrightharpoondownup", "rightleftharpoon"], lang: :asciimath)],
          mathml: ["&#x294b;"],
          latex: [["leftrightharpoondownup", "rightleftharpoon", "&#x294b;"]],
          omml: ["&#x294b;"],
          html: ["&#x294b;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\leftrightharpoondownup"
        end

        def to_asciimath(**)
          parsing_wrapper("rightleftharpoon", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x294b;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x294b;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x294b;"
        end

        def to_html(**)
          "&#x294b;"
        end
      end
    end
  end
end
