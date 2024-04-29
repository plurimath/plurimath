module Plurimath
  module Math
    module Symbols
      class Vardiamond < Symbol
        INPUT = {
          unicodemath: [["&#x2666;"], parsing_wrapper(["vardiamondsuit", "vardiamond"])],
          asciimath: [["&#x2666;"], parsing_wrapper(["vardiamondsuit", "vardiamond"])],
          mathml: ["&#x2666;"],
          latex: [["vardiamondsuit", "vardiamond", "&#x2666;"]],
          omml: ["&#x2666;"],
          html: ["&#x2666;"],
        }.freeze

        # output methods
        def to_latex
          "\\vardiamondsuit"
        end

        def to_asciimath
          parsing_wrapper("vardiamond")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2666;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x2666;"
        end

        def to_omml_without_math_tag(_)
          "&#x2666;"
        end

        def to_html
          "&#x2666;"
        end
      end
    end
  end
end
