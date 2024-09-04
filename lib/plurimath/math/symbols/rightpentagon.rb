module Plurimath
  module Math
    module Symbols
      class Rightpentagon < Symbol
        INPUT = {
          unicodemath: [["&#x2b54;"], parsing_wrapper(["rightpentagon"], lang: :unicode)],
          asciimath: [["&#x2b54;"], parsing_wrapper(["rightpentagon"], lang: :asciimath)],
          mathml: ["&#x2b54;"],
          latex: [["rightpentagon", "&#x2b54;"]],
          omml: ["&#x2b54;"],
          html: ["&#x2b54;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\rightpentagon"
        end

        def to_asciimath(**)
          parsing_wrapper("rightpentagon", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2b54;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2b54;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2b54;"
        end

        def to_html(**)
          "&#x2b54;"
        end
      end
    end
  end
end
