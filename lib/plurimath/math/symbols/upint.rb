module Plurimath
  module Math
    module Symbols
      class Upint < Symbol
        INPUT = {
          unicodemath: [["&#x2a1b;"], parsing_wrapper(["upint"], lang: :unicode)],
          asciimath: [["&#x2a1b;"], parsing_wrapper(["upint"], lang: :asciimath)],
          mathml: ["&#x2a1b;"],
          latex: [["upint", "&#x2a1b;"]],
          omml: ["&#x2a1b;"],
          html: ["&#x2a1b;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\upint"
        end

        def to_asciimath(**)
          parsing_wrapper("upint", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a1b;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a1b;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a1b;"
        end

        def to_html(**)
          "&#x2a1b;"
        end
      end
    end
  end
end
