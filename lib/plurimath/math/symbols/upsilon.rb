module Plurimath
  module Math
    module Symbols
      class Upsilon < Symbol
        INPUT = {
          unicodemath: [["upsilon", "&#x3c5;"], parsing_wrapper(["upupsilon"], lang: :unicode)],
          asciimath: [["upsilon", "&#x3c5;"], parsing_wrapper(["upupsilon"], lang: :asciimath)],
          mathml: ["&#x3c5;"],
          latex: [["upupsilon", "upsilon", "&#x3c5;"]],
          omml: ["&#x3c5;"],
          html: ["&#x3c5;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\upupsilon"
        end

        def to_asciimath(**)
          "upsilon"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x3c5;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x3c5;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x3c5;"
        end

        def to_html(**)
          "&#x3c5;"
        end
      end
    end
  end
end
