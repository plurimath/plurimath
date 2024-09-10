module Plurimath
  module Math
    module Symbols
      class Unicodeellipsis < Symbol
        INPUT = {
          unicodemath: [["&#x2026;"], parsing_wrapper(["unicodeellipsis"], lang: :unicode)],
          asciimath: [["&#x2026;"], parsing_wrapper(["unicodeellipsis"], lang: :asciimath)],
          mathml: ["&#x2026;"],
          latex: [["unicodeellipsis", "&#x2026;"]],
          omml: ["&#x2026;"],
          html: ["&#x2026;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\unicodeellipsis"
        end

        def to_asciimath(**)
          "ldots"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2026;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2026;"
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
