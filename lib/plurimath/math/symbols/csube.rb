module Plurimath
  module Math
    module Symbols
      class Csube < Symbol
        INPUT = {
          unicodemath: [["&#x2ad1;"], parsing_wrapper(["csube"], lang: :unicode)],
          asciimath: [["&#x2ad1;"], parsing_wrapper(["csube"], lang: :asciimath)],
          mathml: ["&#x2ad1;"],
          latex: [["csube", "&#x2ad1;"]],
          omml: ["&#x2ad1;"],
          html: ["&#x2ad1;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\csube"
        end

        def to_asciimath(**)
          parsing_wrapper("csube", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2ad1;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2ad1;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2ad1;"
        end

        def to_html(**)
          "&#x2ad1;"
        end
      end
    end
  end
end
