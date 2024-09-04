module Plurimath
  module Math
    module Symbols
      class Enleadertwodots < Symbol
        INPUT = {
          unicodemath: [["&#x2025;"], parsing_wrapper(["enleadertwodots"], lang: :unicode)],
          asciimath: [["&#x2025;"], parsing_wrapper(["enleadertwodots"], lang: :asciimath)],
          mathml: ["&#x2025;"],
          latex: [["enleadertwodots", "&#x2025;"]],
          omml: ["&#x2025;"],
          html: ["&#x2025;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\enleadertwodots"
        end

        def to_asciimath(**)
          parsing_wrapper("enleadertwodots", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2025;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2025;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2025;"
        end

        def to_html(**)
          "&#x2025;"
        end
      end
    end
  end
end
