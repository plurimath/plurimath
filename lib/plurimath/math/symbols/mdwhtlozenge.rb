module Plurimath
  module Math
    module Symbols
      class Mdwhtlozenge < Symbol
        INPUT = {
          unicodemath: [["&#x2b28;"], parsing_wrapper(["mdwhtlozenge"], lang: :unicode)],
          asciimath: [["&#x2b28;"], parsing_wrapper(["mdwhtlozenge"], lang: :asciimath)],
          mathml: ["&#x2b28;"],
          latex: [["mdwhtlozenge", "&#x2b28;"]],
          omml: ["&#x2b28;"],
          html: ["&#x2b28;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\mdwhtlozenge"
        end

        def to_asciimath(**)
          parsing_wrapper("mdwhtlozenge", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2b28;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2b28;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2b28;"
        end

        def to_html(**)
          "&#x2b28;"
        end
      end
    end
  end
end
