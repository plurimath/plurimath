module Plurimath
  module Math
    module Symbols
      class Lozengeminus < Symbol
        INPUT = {
          unicodemath: [["&#x27e0;"], parsing_wrapper(["lozengeminus"], lang: :unicode)],
          asciimath: [["&#x27e0;"], parsing_wrapper(["lozengeminus"], lang: :asciimath)],
          mathml: ["&#x27e0;"],
          latex: [["lozengeminus", "&#x27e0;"]],
          omml: ["&#x27e0;"],
          html: ["&#x27e0;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\lozengeminus"
        end

        def to_asciimath(**)
          parsing_wrapper("lozengeminus", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x27e0;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x27e0;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x27e0;"
        end

        def to_html(**)
          "&#x27e0;"
        end
      end
    end
  end
end
