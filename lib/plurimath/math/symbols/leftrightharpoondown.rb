module Plurimath
  module Math
    module Symbols
      class Leftrightharpoondown < Symbol
        INPUT = {
          unicodemath: [["&#x2950;"], parsing_wrapper(["leftrightharpoondowndown", "leftrightharpoondown"])],
          asciimath: [["&#x2950;"], parsing_wrapper(["leftrightharpoondowndown", "leftrightharpoondown"])],
          mathml: ["&#x2950;"],
          latex: [["leftrightharpoondowndown", "leftrightharpoondown", "&#x2950;"]],
          omml: ["&#x2950;"],
          html: ["&#x2950;"],
        }.freeze

        # output methods
        def to_latex
          "\\leftrightharpoondowndown"
        end

        def to_asciimath
          parsing_wrapper("leftrightharpoondown")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2950;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x2950;"
        end

        def to_omml_without_math_tag(_)
          "&#x2950;"
        end

        def to_html
          "&#x2950;"
        end
      end
    end
  end
end
