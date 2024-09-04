module Plurimath
  module Math
    module Symbols
      class UpcaseSigma < Symbol
        INPUT = {
          unicodemath: [["Sigma", "&#x3a3;"], parsing_wrapper(["upSigma"], lang: :unicode)],
          asciimath: [["Sigma", "&#x3a3;"], parsing_wrapper(["upSigma"], lang: :asciimath)],
          mathml: ["&#x3a3;"],
          latex: [["upSigma", "Sigma", "&#x3a3;"]],
          omml: ["&#x3a3;"],
          html: ["&#x3a3;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\Sigma"
        end

        def to_asciimath(**)
          "Sigma"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x3a3;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x3a3;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x3a3;"
        end

        def to_html(**)
          "&#x3a3;"
        end
      end
    end
  end
end
