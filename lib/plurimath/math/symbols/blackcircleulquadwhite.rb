module Plurimath
  module Math
    module Symbols
      class Blackcircleulquadwhite < Symbol
        INPUT = {
          unicodemath: [["&#x25d5;"], parsing_wrapper(["blackcircleulquadwhite"], lang: :unicode)],
          asciimath: [["&#x25d5;"], parsing_wrapper(["blackcircleulquadwhite"], lang: :asciimath)],
          mathml: ["&#x25d5;"],
          latex: [["blackcircleulquadwhite", "&#x25d5;"]],
          omml: ["&#x25d5;"],
          html: ["&#x25d5;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\blackcircleulquadwhite"
        end

        def to_asciimath(**)
          parsing_wrapper("blackcircleulquadwhite", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25d5;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25d5;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25d5;"
        end

        def to_html(**)
          "&#x25d5;"
        end
      end
    end
  end
end
