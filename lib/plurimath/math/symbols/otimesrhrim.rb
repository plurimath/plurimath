module Plurimath
  module Math
    module Symbols
      class Otimesrhrim < Symbol
        INPUT = {
          unicodemath: [["&#x2a35;"], parsing_wrapper(["otimesrhrim"], lang: :unicode)],
          asciimath: [["&#x2a35;"], parsing_wrapper(["otimesrhrim"], lang: :asciimath)],
          mathml: ["&#x2a35;"],
          latex: [["otimesrhrim", "&#x2a35;"]],
          omml: ["&#x2a35;"],
          html: ["&#x2a35;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\otimesrhrim"
        end

        def to_asciimath(**)
          parsing_wrapper("otimesrhrim", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a35;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a35;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a35;"
        end

        def to_html(**)
          "&#x2a35;"
        end
      end
    end
  end
end
