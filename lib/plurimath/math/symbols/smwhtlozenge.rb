module Plurimath
  module Math
    module Symbols
      class Smwhtlozenge < Symbol
        INPUT = {
          unicodemath: [["&#x2b2b;"], parsing_wrapper(["smwhtlozenge"], lang: :unicode)],
          asciimath: [["&#x2b2b;"], parsing_wrapper(["smwhtlozenge"], lang: :asciimath)],
          mathml: ["&#x2b2b;"],
          latex: [["smwhtlozenge", "&#x2b2b;"]],
          omml: ["&#x2b2b;"],
          html: ["&#x2b2b;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\smwhtlozenge"
        end

        def to_asciimath(**)
          parsing_wrapper("smwhtlozenge", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2b2b;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2b2b;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2b2b;"
        end

        def to_html(**)
          "&#x2b2b;"
        end
      end
    end
  end
end
