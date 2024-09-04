module Plurimath
  module Math
    module Symbols
      class Varveebar < Symbol
        INPUT = {
          unicodemath: [["&#x2a61;"], parsing_wrapper(["varveebar"], lang: :unicode)],
          asciimath: [["&#x2a61;"], parsing_wrapper(["varveebar"], lang: :asciimath)],
          mathml: ["&#x2a61;"],
          latex: [["varveebar", "&#x2a61;"]],
          omml: ["&#x2a61;"],
          html: ["&#x2a61;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\varveebar"
        end

        def to_asciimath(**)
          parsing_wrapper("varveebar", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a61;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a61;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a61;"
        end

        def to_html(**)
          "&#x2a61;"
        end
      end
    end
  end
end
