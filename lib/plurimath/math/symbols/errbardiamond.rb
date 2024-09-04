module Plurimath
  module Math
    module Symbols
      class Errbardiamond < Symbol
        INPUT = {
          unicodemath: [["&#x29f0;"], parsing_wrapper(["errbardiamond"], lang: :unicode)],
          asciimath: [["&#x29f0;"], parsing_wrapper(["errbardiamond"], lang: :asciimath)],
          mathml: ["&#x29f0;"],
          latex: [["errbardiamond", "&#x29f0;"]],
          omml: ["&#x29f0;"],
          html: ["&#x29f0;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\errbardiamond"
        end

        def to_asciimath(**)
          parsing_wrapper("errbardiamond", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x29f0;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x29f0;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x29f0;"
        end

        def to_html(**)
          "&#x29f0;"
        end
      end
    end
  end
end
