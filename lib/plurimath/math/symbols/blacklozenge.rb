module Plurimath
  module Math
    module Symbols
      class Blacklozenge < Symbol
        INPUT = {
          unicodemath: [["&#x29eb;"], parsing_wrapper(["mdlgblklozenge", "blacklozenge"], lang: :unicode)],
          asciimath: [["&#x29eb;"], parsing_wrapper(["mdlgblklozenge", "blacklozenge"], lang: :asciimath)],
          mathml: ["&#x29eb;"],
          latex: [["mdlgblklozenge", "blacklozenge", "&#x29eb;"]],
          omml: ["&#x29eb;"],
          html: ["&#x29eb;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\mdlgblklozenge"
        end

        def to_asciimath(**)
          parsing_wrapper("blacklozenge", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x29eb;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x29eb;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x29eb;"
        end

        def to_html(**)
          "&#x29eb;"
        end
      end
    end
  end
end
