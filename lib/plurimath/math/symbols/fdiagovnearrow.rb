module Plurimath
  module Math
    module Symbols
      class Fdiagovnearrow < Symbol
        INPUT = {
          unicodemath: [["&#x292f;"], parsing_wrapper(["fdiagovnearrow"], lang: :unicode)],
          asciimath: [["&#x292f;"], parsing_wrapper(["fdiagovnearrow"], lang: :asciimath)],
          mathml: ["&#x292f;"],
          latex: [["fdiagovnearrow", "&#x292f;"]],
          omml: ["&#x292f;"],
          html: ["&#x292f;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\fdiagovnearrow"
        end

        def to_asciimath(**)
          parsing_wrapper("fdiagovnearrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x292f;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x292f;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x292f;"
        end

        def to_html(**)
          "&#x292f;"
        end
      end
    end
  end
end
