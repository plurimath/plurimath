module Plurimath
  module Math
    module Symbols
      class Mdblklozenge < Symbol
        INPUT = {
          unicodemath: [["&#x2b27;"], parsing_wrapper(["mdblklozenge"], lang: :unicode)],
          asciimath: [["&#x2b27;"], parsing_wrapper(["mdblklozenge"], lang: :asciimath)],
          mathml: ["&#x2b27;"],
          latex: [["mdblklozenge", "&#x2b27;"]],
          omml: ["&#x2b27;"],
          html: ["&#x2b27;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\mdblklozenge"
        end

        def to_asciimath(**)
          parsing_wrapper("mdblklozenge", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2b27;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2b27;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2b27;"
        end

        def to_html(**)
          "&#x2b27;"
        end
      end
    end
  end
end
