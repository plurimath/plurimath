module Plurimath
  module Math
    module Symbols
      class Smeparsl < Symbol
        INPUT = {
          unicodemath: [["&#x29e4;"], parsing_wrapper(["smeparsl"], lang: :unicode)],
          asciimath: [["&#x29e4;"], parsing_wrapper(["smeparsl"], lang: :asciimath)],
          mathml: ["&#x29e4;"],
          latex: [["smeparsl", "&#x29e4;"]],
          omml: ["&#x29e4;"],
          html: ["&#x29e4;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\smeparsl"
        end

        def to_asciimath(**)
          parsing_wrapper("smeparsl", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x29e4;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x29e4;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x29e4;"
        end

        def to_html(**)
          "&#x29e4;"
        end
      end
    end
  end
end
