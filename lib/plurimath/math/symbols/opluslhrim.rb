module Plurimath
  module Math
    module Symbols
      class Opluslhrim < Symbol
        INPUT = {
          unicodemath: [["&#x2a2d;"], parsing_wrapper(["opluslhrim"], lang: :unicode)],
          asciimath: [["&#x2a2d;"], parsing_wrapper(["opluslhrim"], lang: :asciimath)],
          mathml: ["&#x2a2d;"],
          latex: [["opluslhrim", "&#x2a2d;"]],
          omml: ["&#x2a2d;"],
          html: ["&#x2a2d;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\opluslhrim"
        end

        def to_asciimath(**)
          parsing_wrapper("opluslhrim", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a2d;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a2d;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a2d;"
        end

        def to_html(**)
          "&#x2a2d;"
        end
      end
    end
  end
end
