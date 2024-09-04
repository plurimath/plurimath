module Plurimath
  module Math
    module Symbols
      class Varstar < Symbol
        INPUT = {
          unicodemath: [["&#x2736;"], parsing_wrapper(["varstar"], lang: :unicode)],
          asciimath: [["&#x2736;"], parsing_wrapper(["varstar"], lang: :asciimath)],
          mathml: ["&#x2736;"],
          latex: [["varstar", "&#x2736;"]],
          omml: ["&#x2736;"],
          html: ["&#x2736;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\varstar"
        end

        def to_asciimath(**)
          parsing_wrapper("varstar", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2736;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2736;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2736;"
        end

        def to_html(**)
          "&#x2736;"
        end
      end
    end
  end
end
