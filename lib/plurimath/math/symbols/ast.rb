module Plurimath
  module Math
    module Symbols
      class Ast < Symbol
        INPUT = {
          unicodemath: [["ast", "&#x2217;"], parsing_wrapper(["**"], lang: :unicode)],
          asciimath: [["**", "ast", "&#x2217;"]],
          mathml: ["&#x2217;"],
          latex: [["ast", "&#x2217;"], parsing_wrapper(["**"], lang: :latex)],
          omml: ["&#x2217;"],
          html: ["&#x2217;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\ast"
        end

        def to_asciimath(**)
          "ast"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2217;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2217;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2217;"
        end

        def to_html(**)
          "&#x2217;"
        end
      end
    end
  end
end
