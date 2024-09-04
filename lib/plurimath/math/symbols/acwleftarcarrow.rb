module Plurimath
  module Math
    module Symbols
      class Acwleftarcarrow < Symbol
        INPUT = {
          unicodemath: [["&#x2939;"], parsing_wrapper(["acwleftarcarrow"], lang: :unicode)],
          asciimath: [["&#x2939;"], parsing_wrapper(["acwleftarcarrow"], lang: :asciimath)],
          mathml: ["&#x2939;"],
          latex: [["acwleftarcarrow", "&#x2939;"]],
          omml: ["&#x2939;"],
          html: ["&#x2939;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\acwleftarcarrow"
        end

        def to_asciimath(**)
          parsing_wrapper("acwleftarcarrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2939;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2939;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2939;"
        end

        def to_html(**)
          "&#x2939;"
        end
      end
    end
  end
end
