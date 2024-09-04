module Plurimath
  module Math
    module Symbols
      class Gtcir < Symbol
        INPUT = {
          unicodemath: [["&#x2a7a;"], parsing_wrapper(["gtcir"], lang: :unicode)],
          asciimath: [["&#x2a7a;"], parsing_wrapper(["gtcir"], lang: :asciimath)],
          mathml: ["&#x2a7a;"],
          latex: [["gtcir", "&#x2a7a;"]],
          omml: ["&#x2a7a;"],
          html: ["&#x2a7a;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\gtcir"
        end

        def to_asciimath(**)
          parsing_wrapper("gtcir", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a7a;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a7a;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a7a;"
        end

        def to_html(**)
          "&#x2a7a;"
        end
      end
    end
  end
end
