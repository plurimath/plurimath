module Plurimath
  module Math
    module Symbols
      class Csup < Symbol
        INPUT = {
          unicodemath: [["&#x2ad0;"], parsing_wrapper(["csup"], lang: :unicode)],
          asciimath: [["&#x2ad0;"], parsing_wrapper(["csup"], lang: :asciimath)],
          mathml: ["&#x2ad0;"],
          latex: [["csup", "&#x2ad0;"]],
          omml: ["&#x2ad0;"],
          html: ["&#x2ad0;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\csup"
        end

        def to_asciimath(**)
          parsing_wrapper("csup", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2ad0;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2ad0;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2ad0;"
        end

        def to_html(**)
          "&#x2ad0;"
        end
      end
    end
  end
end
