module Plurimath
  module Math
    module Symbols
      class Leftrightharpoonup < Symbol
        INPUT = {
          unicodemath: [["&#x294e;"], parsing_wrapper(["leftrightharpoonupup", "leftrightharpoonup"], lang: :unicode)],
          asciimath: [["&#x294e;"], parsing_wrapper(["leftrightharpoonupup", "leftrightharpoonup"], lang: :asciimath)],
          mathml: ["&#x294e;"],
          latex: [["leftrightharpoonupup", "leftrightharpoonup", "&#x294e;"]],
          omml: ["&#x294e;"],
          html: ["&#x294e;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\leftrightharpoonupup"
        end

        def to_asciimath(**)
          parsing_wrapper("leftrightharpoonup", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x294e;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x294e;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x294e;"
        end

        def to_html(**)
          "&#x294e;"
        end
      end
    end
  end
end
