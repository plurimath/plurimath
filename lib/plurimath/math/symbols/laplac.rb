module Plurimath
  module Math
    module Symbols
      class Laplac < Symbol
        INPUT = {
          unicodemath: [["&#x29e0;"], parsing_wrapper(["laplac"], lang: :unicode)],
          asciimath: [["&#x29e0;"], parsing_wrapper(["laplac"], lang: :asciimath)],
          mathml: ["&#x29e0;"],
          latex: [["laplac", "&#x29e0;"]],
          omml: ["&#x29e0;"],
          html: ["&#x29e0;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\laplac"
        end

        def to_asciimath(**)
          parsing_wrapper("laplac", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x29e0;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x29e0;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x29e0;"
        end

        def to_html(**)
          "&#x29e0;"
        end
      end
    end
  end
end
