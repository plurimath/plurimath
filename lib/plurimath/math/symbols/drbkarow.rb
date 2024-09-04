module Plurimath
  module Math
    module Symbols
      class Drbkarow < Symbol
        INPUT = {
          unicodemath: [["&#x2910;"], parsing_wrapper(["drbkarow"], lang: :unicode)],
          asciimath: [["&#x2910;"], parsing_wrapper(["drbkarow"], lang: :asciimath)],
          mathml: ["&#x2910;"],
          latex: [["drbkarow", "&#x2910;"]],
          omml: ["&#x2910;"],
          html: ["&#x2910;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\drbkarow"
        end

        def to_asciimath(**)
          parsing_wrapper("drbkarow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2910;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2910;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2910;"
        end

        def to_html(**)
          "&#x2910;"
        end
      end
    end
  end
end
