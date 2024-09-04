module Plurimath
  module Math
    module Symbols
      class Varvdash < Symbol
        INPUT = {
          unicodemath: [["&#x2ae6;"], parsing_wrapper(["varVdash"], lang: :unicode)],
          asciimath: [["&#x2ae6;"], parsing_wrapper(["varVdash"], lang: :asciimath)],
          mathml: ["&#x2ae6;"],
          latex: [["varVdash", "&#x2ae6;"]],
          omml: ["&#x2ae6;"],
          html: ["&#x2ae6;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\varVdash"
        end

        def to_asciimath(**)
          parsing_wrapper("varVdash", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2ae6;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2ae6;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2ae6;"
        end

        def to_html(**)
          "&#x2ae6;"
        end
      end
    end
  end
end
