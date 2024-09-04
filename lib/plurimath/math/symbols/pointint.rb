module Plurimath
  module Math
    module Symbols
      class Pointint < Symbol
        INPUT = {
          unicodemath: [["&#x2a15;"], parsing_wrapper(["pointint"], lang: :unicode)],
          asciimath: [["&#x2a15;"], parsing_wrapper(["pointint"], lang: :asciimath)],
          mathml: ["&#x2a15;"],
          latex: [["pointint", "&#x2a15;"]],
          omml: ["&#x2a15;"],
          html: ["&#x2a15;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\pointint"
        end

        def to_asciimath(**)
          parsing_wrapper("pointint", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a15;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a15;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a15;"
        end

        def to_html(**)
          "&#x2a15;"
        end
      end
    end
  end
end
