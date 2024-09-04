module Plurimath
  module Math
    module Symbols
      class Lozenge < Symbol
        INPUT = {
          unicodemath: [["&#x25ca;"], parsing_wrapper(["mdlgwhtlozenge", "lozenge"], lang: :unicode)],
          asciimath: [["&#x25ca;"], parsing_wrapper(["mdlgwhtlozenge", "lozenge"], lang: :asciimath)],
          mathml: ["&#x25ca;"],
          latex: [["mdlgwhtlozenge", "lozenge", "&#x25ca;"]],
          omml: ["&#x25ca;"],
          html: ["&#x25ca;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\mdlgwhtlozenge"
        end

        def to_asciimath(**)
          parsing_wrapper("lozenge", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25ca;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25ca;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25ca;"
        end

        def to_html(**)
          "&#x25ca;"
        end
      end
    end
  end
end
