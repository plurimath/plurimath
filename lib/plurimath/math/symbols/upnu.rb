module Plurimath
  module Math
    module Symbols
      class Upnu < Symbol
        INPUT = {
          unicodemath: [["&#x39d;"], parsing_wrapper(["upNu"])],
          asciimath: [["&#x39d;"], parsing_wrapper(["upNu"])],
          mathml: ["&#x39d;"],
          latex: [["upNu", "&#x39d;"]],
          omml: ["&#x39d;"],
          html: ["&#x39d;"],
        }.freeze

        # output methods
        def to_latex
          "\\upNu"
        end

        def to_asciimath
          parsing_wrapper("upNu")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x39d;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x39d;"
        end

        def to_omml_without_math_tag(_)
          "&#x39d;"
        end

        def to_html
          "&#x39d;"
        end
      end
    end
  end
end
