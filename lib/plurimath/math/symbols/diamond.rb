module Plurimath
  module Math
    module Symbols
      class Diamond < Symbol
        INPUT = {
          unicodemath: [["diamond", "&#x22c4;"], parsing_wrapper(["smwhtdiamond"], lang: :unicode)],
          asciimath: [["diamond", "&#x22c4;"], parsing_wrapper(["smwhtdiamond"], lang: :asciimath)],
          mathml: ["&#x22c4;"],
          latex: [["smwhtdiamond", "diamond", "&#x22c4;"]],
          omml: ["&#x22c4;"],
          html: ["&#x22c4;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\smwhtdiamond"
        end

        def to_asciimath(**)
          "diamond"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22c4;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22c4;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22c4;"
        end

        def to_html(**)
          "&#x22c4;"
        end
      end
    end
  end
end
