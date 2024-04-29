module Plurimath
  module Math
    module Symbols
      class Updownharpoonrightleft < Symbol
        INPUT = {
          unicodemath: [["&#x294c;"], parsing_wrapper(["updownharpoonrightleft"])],
          asciimath: [["&#x294c;"], parsing_wrapper(["updownharpoonrightleft"])],
          mathml: ["&#x294c;"],
          latex: [["updownharpoonrightleft", "&#x294c;"]],
          omml: ["&#x294c;"],
          html: ["&#x294c;"],
        }.freeze

        # output methods
        def to_latex
          "\\updownharpoonrightleft"
        end

        def to_asciimath
          parsing_wrapper("updownharpoonrightleft")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x294c;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x294c;"
        end

        def to_omml_without_math_tag(_)
          "&#x294c;"
        end

        def to_html
          "&#x294c;"
        end
      end
    end
  end
end
