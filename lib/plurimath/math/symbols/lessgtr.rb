module Plurimath
  module Math
    module Symbols
      class Lessgtr < Symbol
        INPUT = {
          unicodemath: [["lessgtr", "&#x2276;"]],
          asciimath: [["&#x2276;"], parsing_wrapper(["lessgtr"], lang: :asciimath)],
          mathml: ["&#x2276;"],
          latex: [["lessgtr", "&#x2276;"]],
          omml: ["&#x2276;"],
          html: ["&#x2276;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\lessgtr"
        end

        def to_asciimath(**)
          parsing_wrapper("lessgtr", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2276;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2276;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2276;"
        end

        def to_html(**)
          "&#x2276;"
        end
      end
    end
  end
end
