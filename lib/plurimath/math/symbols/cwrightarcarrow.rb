module Plurimath
  module Math
    module Symbols
      class Cwrightarcarrow < Symbol
        INPUT = {
          unicodemath: [["&#x2938;"], parsing_wrapper(["cwrightarcarrow"], lang: :unicode)],
          asciimath: [["&#x2938;"], parsing_wrapper(["cwrightarcarrow"], lang: :asciimath)],
          mathml: ["&#x2938;"],
          latex: [["cwrightarcarrow", "&#x2938;"]],
          omml: ["&#x2938;"],
          html: ["&#x2938;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\cwrightarcarrow"
        end

        def to_asciimath(**)
          parsing_wrapper("cwrightarcarrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2938;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2938;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2938;"
        end

        def to_html(**)
          "&#x2938;"
        end
      end
    end
  end
end
