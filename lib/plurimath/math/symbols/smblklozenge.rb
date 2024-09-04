module Plurimath
  module Math
    module Symbols
      class Smblklozenge < Symbol
        INPUT = {
          unicodemath: [["&#x2b2a;"], parsing_wrapper(["smblklozenge"], lang: :unicode)],
          asciimath: [["&#x2b2a;"], parsing_wrapper(["smblklozenge"], lang: :asciimath)],
          mathml: ["&#x2b2a;"],
          latex: [["smblklozenge", "&#x2b2a;"]],
          omml: ["&#x2b2a;"],
          html: ["&#x2b2a;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\smblklozenge"
        end

        def to_asciimath(**)
          parsing_wrapper("smblklozenge", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2b2a;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2b2a;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2b2a;"
        end

        def to_html(**)
          "&#x2b2a;"
        end
      end
    end
  end
end
