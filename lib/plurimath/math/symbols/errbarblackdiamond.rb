module Plurimath
  module Math
    module Symbols
      class Errbarblackdiamond < Symbol
        INPUT = {
          unicodemath: [["&#x29f1;"], parsing_wrapper(["errbarblackdiamond"], lang: :unicode)],
          asciimath: [["&#x29f1;"], parsing_wrapper(["errbarblackdiamond"], lang: :asciimath)],
          mathml: ["&#x29f1;"],
          latex: [["errbarblackdiamond", "&#x29f1;"]],
          omml: ["&#x29f1;"],
          html: ["&#x29f1;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\errbarblackdiamond"
        end

        def to_asciimath(**)
          parsing_wrapper("errbarblackdiamond", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x29f1;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x29f1;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x29f1;"
        end

        def to_html(**)
          "&#x29f1;"
        end
      end
    end
  end
end
