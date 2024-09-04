module Plurimath
  module Math
    module Symbols
      class Lparengtr < Symbol
        INPUT = {
          unicodemath: [["&#x2995;"], parsing_wrapper(["Lparengtr"], lang: :unicode)],
          asciimath: [["&#x2995;"], parsing_wrapper(["Lparengtr"], lang: :asciimath)],
          mathml: ["&#x2995;"],
          latex: [["Lparengtr", "&#x2995;"]],
          omml: ["&#x2995;"],
          html: ["&#x2995;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\Lparengtr"
        end

        def to_asciimath(**)
          parsing_wrapper("Lparengtr", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2995;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2995;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2995;"
        end

        def to_html(**)
          "&#x2995;"
        end
      end
    end
  end
end
