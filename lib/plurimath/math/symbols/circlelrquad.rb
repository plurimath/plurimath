module Plurimath
  module Math
    module Symbols
      class Circlelrquad < Symbol
        INPUT = {
          unicodemath: [["&#x25f6;"], parsing_wrapper(["circlelrquad"], lang: :unicode)],
          asciimath: [["&#x25f6;"], parsing_wrapper(["circlelrquad"], lang: :asciimath)],
          mathml: ["&#x25f6;"],
          latex: [["circlelrquad", "&#x25f6;"]],
          omml: ["&#x25f6;"],
          html: ["&#x25f6;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\circlelrquad"
        end

        def to_asciimath(**)
          parsing_wrapper("circlelrquad", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25f6;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25f6;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25f6;"
        end

        def to_html(**)
          "&#x25f6;"
        end
      end
    end
  end
end
