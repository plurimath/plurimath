module Plurimath
  module Math
    module Symbols
      class Psi < Symbol
        INPUT = {
          unicodemath: [["psi", "&#x3c8;"], parsing_wrapper(["uppsi"], lang: :unicode)],
          asciimath: [["psi", "&#x3c8;"], parsing_wrapper(["uppsi"], lang: :asciimath)],
          mathml: ["&#x3c8;"],
          latex: [["uppsi", "psi", "&#x3c8;"]],
          omml: ["&#x3c8;"],
          html: ["&#x3c8;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\psi"
        end

        def to_asciimath(**)
          "psi"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x3c8;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x3c8;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x3c8;"
        end

        def to_html(**)
          "&#x3c8;"
        end
      end
    end
  end
end
