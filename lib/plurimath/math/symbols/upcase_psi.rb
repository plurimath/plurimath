module Plurimath
  module Math
    module Symbols
      class UpcasePsi < Symbol
        INPUT = {
          unicodemath: [["Psi", "&#x3a8;"], parsing_wrapper(["upPsi"], lang: :unicode)],
          asciimath: [["Psi", "&#x3a8;"], parsing_wrapper(["upPsi"], lang: :asciimath)],
          mathml: ["&#x3a8;"],
          latex: [["upPsi", "Psi", "&#x3a8;"]],
          omml: ["&#x3a8;"],
          html: ["&#x3a8;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\Psi"
        end

        def to_asciimath(**)
          "Psi"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x3a8;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x3a8;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x3a8;"
        end

        def to_html(**)
          "&#x3a8;"
        end
      end
    end
  end
end
