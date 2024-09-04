module Plurimath
  module Math
    module Symbols
      class Succsim < Symbol
        INPUT = {
          unicodemath: [["succsim", "&#x227f;"], parsing_wrapper(["SucceedsTilde"], lang: :unicode)],
          asciimath: [["&#x227f;"], parsing_wrapper(["succsim", "SucceedsTilde"], lang: :asciimath)],
          mathml: ["&#x227f;"],
          latex: [["SucceedsTilde", "succsim", "&#x227f;"]],
          omml: ["&#x227f;"],
          html: ["&#x227f;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\SucceedsTilde"
        end

        def to_asciimath(**)
          parsing_wrapper("succsim", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x227f;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x227f;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x227f;"
        end

        def to_html(**)
          "&#x227f;"
        end
      end
    end
  end
end
