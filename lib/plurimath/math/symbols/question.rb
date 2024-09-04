module Plurimath
  module Math
    module Symbols
      class Question < Symbol
        INPUT = {
          unicodemath: [["&#x3f;", "?"], parsing_wrapper(["question"], lang: :unicode)],
          asciimath: [["&#x3f;", "?"], parsing_wrapper(["question"], lang: :asciimath)],
          mathml: ["&#x3f;"],
          latex: [["question", "?", "&#x3f;"]],
          omml: ["&#x3f;"],
          html: ["&#x3f;"],
        }.freeze

        # output methods
        def to_latex(**)
          "?"
        end

        def to_asciimath(**)
          "?"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x3f;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x3f;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x3f;"
        end

        def to_html(**)
          "&#x3f;"
        end
      end
    end
  end
end
