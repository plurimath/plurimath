module Plurimath
  module Math
    module Symbols
      class Hkswarow < Symbol
        INPUT = {
          unicodemath: [["&#x2926;"], parsing_wrapper(["hkswarow"])],
          asciimath: [["&#x2926;"], parsing_wrapper(["hkswarow"])],
          mathml: ["&#x2926;"],
          latex: [["hkswarow", "&#x2926;"]],
          omml: ["&#x2926;"],
          html: ["&#x2926;"],
        }.freeze

        # output methods
        def to_latex
          "\\hkswarow"
        end

        def to_asciimath
          parsing_wrapper("hkswarow")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2926;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x2926;"
        end

        def to_omml_without_math_tag(_)
          "&#x2926;"
        end

        def to_html
          "&#x2926;"
        end
      end
    end
  end
end
