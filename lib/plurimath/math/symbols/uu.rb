module Plurimath
  module Math
    module Symbols
      class Uu < Symbol
        INPUT = {
          unicodemath: [["cup", "&#x222a;"], parsing_wrapper(["uu"], lang: :unicode)],
          asciimath: [["cup", "uu", "&#x222a;"]],
          mathml: ["&#x222a;"],
          latex: [["cup", "&#x222a;"], parsing_wrapper(["uu"], lang: :latex)],
          omml: ["&#x222a;"],
          html: ["&#x222a;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\cup"
        end

        def to_asciimath(**)
          "uu"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x222a;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mo") << "&#x222a;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x222a;"
        end

        def to_html(**)
          "&#x222a;"
        end
      end
    end
  end
end
