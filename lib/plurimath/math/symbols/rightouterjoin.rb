module Plurimath
  module Math
    module Symbols
      class Rightouterjoin < Symbol
        INPUT = {
          unicodemath: [["&#x27d6;"], parsing_wrapper(["rightouterjoin"], lang: :unicode)],
          asciimath: [["&#x27d6;"], parsing_wrapper(["rightouterjoin"], lang: :asciimath)],
          mathml: ["&#x27d6;"],
          latex: [["rightouterjoin", "&#x27d6;"]],
          omml: ["&#x27d6;"],
          html: ["&#x27d6;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\rightouterjoin"
        end

        def to_asciimath(**)
          parsing_wrapper("rightouterjoin", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x27d6;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x27d6;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x27d6;"
        end

        def to_html(**)
          "&#x27d6;"
        end
      end
    end
  end
end
