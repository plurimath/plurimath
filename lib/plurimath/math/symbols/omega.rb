module Plurimath
  module Math
    module Symbols
      class Omega < Symbol
        INPUT = {
          unicodemath: [["omega", "&#x3c9;"], parsing_wrapper(["upomega"], lang: :unicode)],
          asciimath: [["omega", "&#x3c9;"], parsing_wrapper(["upomega"], lang: :asciimath)],
          mathml: ["&#x3c9;"],
          latex: [["upomega", "omega", "&#x3c9;"]],
          omml: ["&#x3c9;"],
          html: ["&#x3c9;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\upomega"
        end

        def to_asciimath(**)
          "omega"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x3c9;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x3c9;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x3c9;"
        end

        def to_html(**)
          "&#x3c9;"
        end
      end
    end
  end
end
