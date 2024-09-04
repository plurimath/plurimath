module Plurimath
  module Math
    module Symbols
      class Csupe < Symbol
        INPUT = {
          unicodemath: [["&#x2ad2;"], parsing_wrapper(["csupe"], lang: :unicode)],
          asciimath: [["&#x2ad2;"], parsing_wrapper(["csupe"], lang: :asciimath)],
          mathml: ["&#x2ad2;"],
          latex: [["csupe", "&#x2ad2;"]],
          omml: ["&#x2ad2;"],
          html: ["&#x2ad2;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\csupe"
        end

        def to_asciimath(**)
          parsing_wrapper("csupe", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2ad2;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2ad2;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2ad2;"
        end

        def to_html(**)
          "&#x2ad2;"
        end
      end
    end
  end
end
