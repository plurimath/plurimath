module Plurimath
  module Math
    module Symbols
      class Minus < Symbol
        INPUT = {
          unicodemath: [["&#x2212;", "-"], parsing_wrapper(["minus"], lang: :unicode)],
          asciimath: [["-", "&#x2212;"], parsing_wrapper(["minus"], lang: :asciimath)],
          mathml: ["&#x2212;", "-"],
          latex: [["minus", "-", "&#x2212;"]],
          omml: ["&#x2212;"],
          html: ["&#x2212;"],
        }.freeze

        # output methods
        def to_latex(**)
          "-"
        end

        def to_asciimath(**)
          "-"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2212;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mo") << "&#x2212;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2212;"
        end

        def to_html(**)
          "&#x2212;"
        end
      end
    end
  end
end
