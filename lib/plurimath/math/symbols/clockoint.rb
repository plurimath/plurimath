module Plurimath
  module Math
    module Symbols
      class Clockoint < Symbol
        INPUT = {
          unicodemath: [["&#x2232;"], parsing_wrapper(["varointclockwise", "clockoint"], lang: :unicode)],
          asciimath: [["&#x2232;"], parsing_wrapper(["varointclockwise", "clockoint"], lang: :asciimath)],
          mathml: ["&#x2232;"],
          latex: [["varointclockwise", "clockoint", "&#x2232;"]],
          omml: ["&#x2232;"],
          html: ["&#x2232;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\varointclockwise"
        end

        def to_asciimath(**)
          parsing_wrapper("clockoint", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2232;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2232;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2232;"
        end

        def to_html(**)
          "&#x2232;"
        end

        def is_nary_symbol?
          true
        end

        def nary_intent_name
          ":n-ary"
        end

        def tag_name
          "underover"
        end

        def omml_tag_name
          "undOvr"
        end
      end
    end
  end
end
