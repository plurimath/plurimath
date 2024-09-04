module Plurimath
  module Math
    module Symbols
      class Precapprox < Symbol
        INPUT = {
          unicodemath: [["&#x2ab7;"], parsing_wrapper(["precapprox"], lang: :unicode)],
          asciimath: [["&#x2ab7;"], parsing_wrapper(["precapprox"], lang: :asciimath)],
          mathml: ["&#x2ab7;"],
          latex: [["precapprox", "&#x2ab7;"]],
          omml: ["&#x2ab7;"],
          html: ["&#x2ab7;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\precapprox"
        end

        def to_asciimath(**)
          parsing_wrapper("precapprox", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2ab7;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2ab7;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2ab7;"
        end

        def to_html(**)
          "&#x2ab7;"
        end
      end
    end
  end
end
