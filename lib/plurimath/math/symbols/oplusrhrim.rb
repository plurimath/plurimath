module Plurimath
  module Math
    module Symbols
      class Oplusrhrim < Symbol
        INPUT = {
          unicodemath: [["&#x2a2e;"], parsing_wrapper(["oplusrhrim"], lang: :unicode)],
          asciimath: [["&#x2a2e;"], parsing_wrapper(["oplusrhrim"], lang: :asciimath)],
          mathml: ["&#x2a2e;"],
          latex: [["oplusrhrim", "&#x2a2e;"]],
          omml: ["&#x2a2e;"],
          html: ["&#x2a2e;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\oplusrhrim"
        end

        def to_asciimath(**)
          parsing_wrapper("oplusrhrim", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a2e;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a2e;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a2e;"
        end

        def to_html(**)
          "&#x2a2e;"
        end
      end
    end
  end
end
