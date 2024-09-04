module Plurimath
  module Math
    module Symbols
      class Rparengtr < Symbol
        INPUT = {
          unicodemath: [["&#x2994;"], parsing_wrapper(["rparengtr"], lang: :unicode)],
          asciimath: [["&#x2994;"], parsing_wrapper(["rparengtr"], lang: :asciimath)],
          mathml: ["&#x2994;"],
          latex: [["rparengtr", "&#x2994;"]],
          omml: ["&#x2994;"],
          html: ["&#x2994;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\rparengtr"
        end

        def to_asciimath(**)
          parsing_wrapper("rparengtr", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2994;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2994;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2994;"
        end

        def to_html(**)
          "&#x2994;"
        end
      end
    end
  end
end
