module Plurimath
  module Math
    module Symbols
      class Circleulquad < Symbol
        INPUT = {
          unicodemath: [["&#x25f4;"], parsing_wrapper(["circleulquad"], lang: :unicode)],
          asciimath: [["&#x25f4;"], parsing_wrapper(["circleulquad"], lang: :asciimath)],
          mathml: ["&#x25f4;"],
          latex: [["circleulquad", "&#x25f4;"]],
          omml: ["&#x25f4;"],
          html: ["&#x25f4;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\circleulquad"
        end

        def to_asciimath(**)
          parsing_wrapper("circleulquad", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25f4;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25f4;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25f4;"
        end

        def to_html(**)
          "&#x25f4;"
        end
      end
    end
  end
end
