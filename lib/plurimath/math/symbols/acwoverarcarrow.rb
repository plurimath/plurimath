module Plurimath
  module Math
    module Symbols
      class Acwoverarcarrow < Symbol
        INPUT = {
          unicodemath: [["&#x293a;"], parsing_wrapper(["acwoverarcarrow"], lang: :unicode)],
          asciimath: [["&#x293a;"], parsing_wrapper(["acwoverarcarrow"], lang: :asciimath)],
          mathml: ["&#x293a;"],
          latex: [["acwoverarcarrow", "&#x293a;"]],
          omml: ["&#x293a;"],
          html: ["&#x293a;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\acwoverarcarrow"
        end

        def to_asciimath(**)
          parsing_wrapper("acwoverarcarrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x293a;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x293a;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x293a;"
        end

        def to_html(**)
          "&#x293a;"
        end
      end
    end
  end
end
