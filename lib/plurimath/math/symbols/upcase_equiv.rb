module Plurimath
  module Math
    module Symbols
      class UpcaseEquiv < Symbol
        INPUT = {
          unicodemath: [["&#x2263;"], parsing_wrapper(["UpcaseEquiv"], lang: :unicode)],
          asciimath: [["&#x2263;"], parsing_wrapper(["UpcaseEquiv"], lang: :asciimath)],
          mathml: ["&#x2263;"],
          latex: [["Equiv", "&#x2263;"]],
          omml: ["&#x2263;"],
          html: ["&#x2263;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\Equiv"
        end

        def to_asciimath(**)
          parsing_wrapper("Equiv", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2263;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2263;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2263;"
        end

        def to_html(**)
          "&#x2263;"
        end
      end
    end
  end
end
