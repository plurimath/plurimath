module Plurimath
  module Math
    module Symbols
      class Fullouterjoin < Symbol
        INPUT = {
          unicodemath: [["&#x27d7;"], parsing_wrapper(["fullouterjoin"], lang: :unicode)],
          asciimath: [["&#x27d7;"], parsing_wrapper(["fullouterjoin"], lang: :asciimath)],
          mathml: ["&#x27d7;"],
          latex: [["fullouterjoin", "&#x27d7;"]],
          omml: ["&#x27d7;"],
          html: ["&#x27d7;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\fullouterjoin"
        end

        def to_asciimath(**)
          parsing_wrapper("fullouterjoin", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x27d7;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x27d7;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x27d7;"
        end

        def to_html(**)
          "&#x27d7;"
        end
      end
    end
  end
end
