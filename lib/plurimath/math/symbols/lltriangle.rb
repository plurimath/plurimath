module Plurimath
  module Math
    module Symbols
      class Lltriangle < Symbol
        INPUT = {
          unicodemath: [["&#x25fa;"], parsing_wrapper(["lltriangle"], lang: :unicode)],
          asciimath: [["&#x25fa;"], parsing_wrapper(["lltriangle"], lang: :asciimath)],
          mathml: ["&#x25fa;"],
          latex: [["lltriangle", "&#x25fa;"]],
          omml: ["&#x25fa;"],
          html: ["&#x25fa;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\lltriangle"
        end

        def to_asciimath(**)
          parsing_wrapper("lltriangle", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25fa;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25fa;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25fa;"
        end

        def to_html(**)
          "&#x25fa;"
        end
      end
    end
  end
end
