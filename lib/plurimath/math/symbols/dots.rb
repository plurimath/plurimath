module Plurimath
  module Math
    module Symbols
      class Dots < Symbol
        INPUT = {
          unicodemath: [["ldots", "...", "dots", "&#x2026;"], parsing_wrapper(["unicodeellipsis"], lang: :unicode)],
          asciimath: [["ldots", "...", "&#x2026;"], parsing_wrapper(["dots", "unicodeellipsis"], lang: :asciimath)],
          mathml: ["&#x2026;"],
          latex: [["unicodeellipsis", "ldots", "&#x2026;"], parsing_wrapper(["...", "dots"], lang: :latex)],
          omml: ["&#x2026;"],
          html: ["&#x2026;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\ldots"
        end

        def to_asciimath(**)
          "..."
        end

        def to_unicodemath(**)
          "..."
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mo") << "&#x2026;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2026;"
        end

        def to_html(**)
          "&#x2026;"
        end
      end
    end
  end
end
