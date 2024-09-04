module Plurimath
  module Math
    module Symbols
      class Kappa < Symbol
        INPUT = {
          unicodemath: [["kappa", "&#x3ba;"], parsing_wrapper(["upkappa"], lang: :unicode)],
          asciimath: [["kappa", "&#x3ba;"], parsing_wrapper(["upkappa"], lang: :asciimath)],
          mathml: ["&#x3ba;"],
          latex: [["upkappa", "kappa", "&#x3ba;"]],
          omml: ["&#x3ba;"],
          html: ["&#x3ba;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\kappa"
        end

        def to_asciimath(**)
          "kappa"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x3ba;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x3ba;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x3ba;"
        end

        def to_html(**)
          "&#x3ba;"
        end
      end
    end
  end
end
