module Plurimath
  module Math
    module Symbols
      class Uminus < Symbol
        INPUT = {
          unicodemath: [["&#x2a41;"], parsing_wrapper(["uminus"], lang: :unicode)],
          asciimath: [["&#x2a41;"], parsing_wrapper(["uminus"], lang: :asciimath)],
          mathml: ["&#x2a41;"],
          latex: [["uminus", "&#x2a41;"]],
          omml: ["&#x2a41;"],
          html: ["&#x2a41;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\uminus"
        end

        def to_asciimath(**)
          parsing_wrapper("uminus", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a41;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a41;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a41;"
        end

        def to_html(**)
          "&#x2a41;"
        end
      end
    end
  end
end
