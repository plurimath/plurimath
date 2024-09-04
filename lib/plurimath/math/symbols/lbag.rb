module Plurimath
  module Math
    module Symbols
      class Lbag < Symbol
        INPUT = {
          unicodemath: [["&#x27c5;"], parsing_wrapper(["Lbag", "lbag"], lang: :unicode)],
          asciimath: [["&#x27c5;"], parsing_wrapper(["Lbag", "lbag"], lang: :asciimath)],
          mathml: ["&#x27c5;"],
          latex: [["Lbag", "lbag", "&#x27c5;"]],
          omml: ["&#x27c5;"],
          html: ["&#x27c5;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\Lbag"
        end

        def to_asciimath(**)
          parsing_wrapper("lbag", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x27c5;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x27c5;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x27c5;"
        end

        def to_html(**)
          "&#x27c5;"
        end
      end
    end
  end
end
