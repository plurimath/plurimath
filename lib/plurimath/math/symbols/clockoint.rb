module Plurimath
  module Math
    module Symbols
      class Clockoint < Symbol
        INPUT = {
          unicodemath: [["&#x2232;"], parsing_wrapper(["varointclockwise", "clockoint"])],
          asciimath: [["&#x2232;"], parsing_wrapper(["varointclockwise", "clockoint"])],
          mathml: ["&#x2232;"],
          latex: [["varointclockwise", "clockoint", "&#x2232;"]],
          omml: ["&#x2232;"],
          html: ["&#x2232;"],
        }.freeze

        # output methods
        def to_latex
          "\\varointclockwise"
        end

        def to_asciimath
          parsing_wrapper("clockoint")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2232;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x2232;"
        end

        def to_omml_without_math_tag(_)
          "&#x2232;"
        end

        def to_html
          "&#x2232;"
        end

        def is_nary_symbol?
          true
        end
      end
    end
  end
end
