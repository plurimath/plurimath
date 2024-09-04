module Plurimath
  module Math
    module Symbols
      class Upepsilon < Symbol
        INPUT = {
          unicodemath: [["&#x395;"], parsing_wrapper(["upEpsilon"], lang: :unicode)],
          asciimath: [["&#x395;"], parsing_wrapper(["upEpsilon"], lang: :asciimath)],
          mathml: ["&#x395;"],
          latex: [["upEpsilon", "&#x395;"]],
          omml: ["&#x395;"],
          html: ["&#x395;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\upEpsilon"
        end

        def to_asciimath(**)
          parsing_wrapper("upEpsilon", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x395;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x395;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x395;"
        end

        def to_html(**)
          "&#x395;"
        end
      end
    end
  end
end
