module Plurimath
  module Math
    module Symbols
      class Backepsilon < Symbol
        INPUT = {
          unicodemath: [["&#x3f6;"], parsing_wrapper(["upbackepsilon", "backepsilon"], lang: :unicode)],
          asciimath: [["&#x3f6;"], parsing_wrapper(["upbackepsilon", "backepsilon"], lang: :asciimath)],
          mathml: ["&#x3f6;"],
          latex: [["upbackepsilon", "backepsilon", "&#x3f6;"]],
          omml: ["&#x3f6;"],
          html: ["&#x3f6;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\backepsilon"
        end

        def to_asciimath(**)
          parsing_wrapper("backepsilon", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x3f6;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x3f6;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x3f6;"
        end

        def to_html(**)
          "&#x3f6;"
        end
      end
    end
  end
end
