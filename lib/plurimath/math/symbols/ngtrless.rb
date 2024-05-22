module Plurimath
  module Math
    module Symbols
      class Ngtrless < Symbol
        INPUT = {
          unicodemath: [["&#x2279;"], parsing_wrapper(["NotGreaterLess", "ngtrless"])],
          asciimath: [["&#x2279;"], parsing_wrapper(["NotGreaterLess", "ngtrless"])],
          mathml: ["&#x2279;"],
          latex: [["NotGreaterLess", "ngtrless", "&#x2279;"]],
          omml: ["&#x2279;"],
          html: ["&#x2279;"],
        }.freeze

        # output methods
        def to_latex
          "\\NotGreaterLess"
        end

        def to_asciimath
          parsing_wrapper("ngtrless")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2279;")
        end

        def to_mathml_without_math_tag(_)
          ox_element("mi") << "&#x2279;"
        end

        def to_omml_without_math_tag(_)
          "&#x2279;"
        end

        def to_html
          "&#x2279;"
        end
      end
    end
  end
end
