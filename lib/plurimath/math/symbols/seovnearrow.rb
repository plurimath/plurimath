module Plurimath
  module Math
    module Symbols
      class Seovnearrow < Symbol
        INPUT = {
          unicodemath: [["&#x292d;"], parsing_wrapper(["seovnearrow"])],
          asciimath: [["&#x292d;"], parsing_wrapper(["seovnearrow"])],
          mathml: ["&#x292d;"],
          latex: [["seovnearrow", "&#x292d;"]],
          omml: ["&#x292d;"],
          html: ["&#x292d;"],
        }.freeze

        # output methods
        def to_latex
          "\\seovnearrow"
        end

        def to_asciimath
          parsing_wrapper("seovnearrow")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x292d;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x292d;"
        end

        def to_omml_without_math_tag(_)
          "&#x292d;"
        end

        def to_html
          "&#x292d;"
        end
      end
    end
  end
end
