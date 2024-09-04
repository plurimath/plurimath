module Plurimath
  module Math
    module Symbols
      class Upkappa < Symbol
        INPUT = {
          unicodemath: [["&#x39a;"], parsing_wrapper(["upKappa"], lang: :unicode)],
          asciimath: [["&#x39a;"], parsing_wrapper(["upKappa"], lang: :asciimath)],
          mathml: ["&#x39a;"],
          latex: [["upKappa", "&#x39a;"]],
          omml: ["&#x39a;"],
          html: ["&#x39a;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\upKappa"
        end

        def to_asciimath(**)
          parsing_wrapper("upKappa", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x39a;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x39a;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x39a;"
        end

        def to_html(**)
          "&#x39a;"
        end
      end
    end
  end
end
