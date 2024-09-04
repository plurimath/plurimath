module Plurimath
  module Math
    module Symbols
      class Leftouterjoin < Symbol
        INPUT = {
          unicodemath: [["&#x27d5;"], parsing_wrapper(["leftouterjoin"], lang: :unicode)],
          asciimath: [["&#x27d5;"], parsing_wrapper(["leftouterjoin"], lang: :asciimath)],
          mathml: ["&#x27d5;"],
          latex: [["leftouterjoin", "&#x27d5;"]],
          omml: ["&#x27d5;"],
          html: ["&#x27d5;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\leftouterjoin"
        end

        def to_asciimath(**)
          parsing_wrapper("leftouterjoin", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x27d5;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x27d5;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x27d5;"
        end

        def to_html(**)
          "&#x27d5;"
        end
      end
    end
  end
end
