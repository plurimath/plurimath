module Plurimath
  module Math
    module Symbols
      class Perp < Symbol
        INPUT = {
          unicodemath: [["bot", "perp", "&#x22a5;"], parsing_wrapper(["_|_"], lang: :unicode)],
          asciimath: [["_|_", "bot", "&#x22a5;"], parsing_wrapper(["perp"], lang: :asciimath)],
          mathml: ["&#x22a5;"],
          latex: [["bot", "&#x22a5;"], parsing_wrapper(["perp", "_|_"], lang: :latex)],
          omml: ["&#x22a5;"],
          html: ["&#x22a5;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\bot"
        end

        def to_asciimath(**)
          "_|_"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22a5;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22a5;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22a5;"
        end

        def to_html(**)
          "&#x22a5;"
        end
      end
    end
  end
end
