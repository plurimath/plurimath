module Plurimath
  module Math
    module Symbols
      class Backtrprime < Symbol
        INPUT = {
          unicodemath: [["&#x2037;"], parsing_wrapper(["backtrprime"], lang: :unicode)],
          asciimath: [["&#x2037;"], parsing_wrapper(["backtrprime"], lang: :asciimath)],
          mathml: ["&#x2037;"],
          latex: [["backtrprime", "&#x2037;"]],
          omml: ["&#x2037;"],
          html: ["&#x2037;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\backtrprime"
        end

        def to_asciimath(**)
          parsing_wrapper("backtrprime", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2037;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2037;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2037;"
        end

        def to_html(**)
          "&#x2037;"
        end
      end
    end
  end
end
