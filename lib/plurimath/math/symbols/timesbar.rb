module Plurimath
  module Math
    module Symbols
      class Timesbar < Symbol
        INPUT = {
          unicodemath: [["&#x2a31;"], parsing_wrapper(["timesbar"])],
          asciimath: [["&#x2a31;"], parsing_wrapper(["timesbar"])],
          mathml: ["&#x2a31;"],
          latex: [["timesbar", "&#x2a31;"]],
          omml: ["&#x2a31;"],
          html: ["&#x2a31;"],
        }.freeze

        # output methods
        def to_latex
          "\\timesbar"
        end

        def to_asciimath
          parsing_wrapper("timesbar")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2a31;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x2a31;"
        end

        def to_omml_without_math_tag(_)
          "&#x2a31;"
        end

        def to_html
          "&#x2a31;"
        end
      end
    end
  end
end
