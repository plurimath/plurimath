module Plurimath
  module Math
    module Symbols
      class Vartriangleright < Symbol
        INPUT = {
          unicodemath: [["vartriangleright", "&#x22b3;"]],
          asciimath: [["&#x22b3;"], parsing_wrapper(["vartriangleright"], lang: :asciimath)],
          mathml: ["&#x22b3;"],
          latex: [["vartriangleright", "&#x22b3;"]],
          omml: ["&#x22b3;"],
          html: ["&#x22b3;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\vartriangleright"
        end

        def to_asciimath(**)
          parsing_wrapper("vartriangleright", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22b3;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22b3;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22b3;"
        end

        def to_html(**)
          "&#x22b3;"
        end
      end
    end
  end
end
