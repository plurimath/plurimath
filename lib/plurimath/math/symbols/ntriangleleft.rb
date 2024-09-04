module Plurimath
  module Math
    module Symbols
      class Ntriangleleft < Symbol
        INPUT = {
          unicodemath: [["ntriangleleft", "&#x22ea;"], parsing_wrapper(["NotLeftTriangle"], lang: :unicode)],
          asciimath: [["&#x22ea;"], parsing_wrapper(["ntriangleleft", "NotLeftTriangle"], lang: :asciimath)],
          mathml: ["&#x22ea;"],
          latex: [["NotLeftTriangle", "ntriangleleft", "&#x22ea;"]],
          omml: ["&#x22ea;"],
          html: ["&#x22ea;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\NotLeftTriangle"
        end

        def to_asciimath(**)
          parsing_wrapper("ntriangleleft", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22ea;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22ea;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22ea;"
        end

        def to_html(**)
          "&#x22ea;"
        end
      end
    end
  end
end
