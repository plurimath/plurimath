module Plurimath
  module Math
    module Symbols
      class Sigma < Symbol
        INPUT = {
          unicodemath: [["sigma", "&#x3c3;"], parsing_wrapper(["upsigma"], lang: :unicode)],
          asciimath: [["sigma", "&#x3c3;"], parsing_wrapper(["upsigma"], lang: :asciimath)],
          mathml: ["&#x3c3;"],
          latex: [["upsigma", "sigma", "&#x3c3;"]],
          omml: ["&#x3c3;"],
          html: ["&#x3c3;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\sigma"
        end

        def to_asciimath(**)
          "sigma"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x3c3;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x3c3;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x3c3;"
        end

        def to_html(**)
          "&#x3c3;"
        end
      end
    end
  end
end
