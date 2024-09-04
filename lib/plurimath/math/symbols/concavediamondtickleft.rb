module Plurimath
  module Math
    module Symbols
      class Concavediamondtickleft < Symbol
        INPUT = {
          unicodemath: [["&#x27e2;"], parsing_wrapper(["concavediamondtickleft"], lang: :unicode)],
          asciimath: [["&#x27e2;"], parsing_wrapper(["concavediamondtickleft"], lang: :asciimath)],
          mathml: ["&#x27e2;"],
          latex: [["concavediamondtickleft", "&#x27e2;"]],
          omml: ["&#x27e2;"],
          html: ["&#x27e2;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\concavediamondtickleft"
        end

        def to_asciimath(**)
          parsing_wrapper("concavediamondtickleft", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x27e2;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x27e2;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x27e2;"
        end

        def to_html(**)
          "&#x27e2;"
        end
      end
    end
  end
end
