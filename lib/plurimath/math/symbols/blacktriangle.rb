module Plurimath
  module Math
    module Symbols
      class Blacktriangle < Symbol
        INPUT = {
          unicodemath: [["&#x25b4;"], parsing_wrapper(["blacktriangleup", "blacktriangle"], lang: :unicode)],
          asciimath: [["&#x25b4;"], parsing_wrapper(["blacktriangleup", "blacktriangle"], lang: :asciimath)],
          mathml: ["&#x25b4;"],
          latex: [["blacktriangleup", "blacktriangle", "&#x25b4;"]],
          omml: ["&#x25b4;"],
          html: ["&#x25b4;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\blacktriangleup"
        end

        def to_asciimath(**)
          parsing_wrapper("blacktriangle", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25b4;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25b4;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25b4;"
        end

        def to_html(**)
          "&#x25b4;"
        end
      end
    end
  end
end
