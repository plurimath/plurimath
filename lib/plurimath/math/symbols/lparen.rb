module Plurimath
  module Math
    module Symbols
      class Lparen < Symbol
        INPUT = {
          unicodemath: [["&#x28;"], parsing_wrapper(["lparen"])],
          asciimath: [["&#x28;"], parsing_wrapper(["lparen"])],
          mathml: ["&#x28;"],
          latex: [["lparen", "&#x28;"]],
          omml: ["&#x28;"],
          html: ["&#x28;"],
        }.freeze

        # output methods
        def to_latex
          "\\lparen"
        end

        def to_asciimath
          parsing_wrapper("lparen")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x28;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x28;"
        end

        def to_omml_without_math_tag(_)
          "&#x28;"
        end

        def to_html
          "&#x28;"
        end
      end
    end
  end
end
