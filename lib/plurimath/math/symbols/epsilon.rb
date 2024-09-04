module Plurimath
  module Math
    module Symbols
      class Epsilon < Symbol
        INPUT = {
          unicodemath: [["varepsilon", "&#x3b5;"], parsing_wrapper(["epsilon", "upepsilon"], lang: :unicode)],
          asciimath: [["epsilon", "&#x3b5;"], parsing_wrapper(["varepsilon", "upepsilon"], lang: :asciimath)],
          mathml: ["&#x3b5;"],
          latex: [["upepsilon", "epsilon", "&#x3b5;"], parsing_wrapper(["varepsilon"], lang: :latex)],
          omml: ["&#x3b5;"],
          html: ["&#x3b5;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\varepsilon"
        end

        def to_asciimath(**)
          "epsilon"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x3b5;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x3b5;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x3b5;"
        end

        def to_html(**)
          "&#x3b5;"
        end
      end
    end
  end
end
