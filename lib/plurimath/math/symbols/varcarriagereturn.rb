module Plurimath
  module Math
    module Symbols
      class Varcarriagereturn < Symbol
        INPUT = {
          unicodemath: [["&#x23ce;"], parsing_wrapper(["varcarriagereturn"], lang: :unicode)],
          asciimath: [["&#x23ce;"], parsing_wrapper(["varcarriagereturn"], lang: :asciimath)],
          mathml: ["&#x23ce;"],
          latex: [["varcarriagereturn", "&#x23ce;"]],
          omml: ["&#x23ce;"],
          html: ["&#x23ce;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\varcarriagereturn"
        end

        def to_asciimath(**)
          parsing_wrapper("varcarriagereturn", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x23ce;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x23ce;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x23ce;"
        end

        def to_html(**)
          "&#x23ce;"
        end
      end
    end
  end
end
