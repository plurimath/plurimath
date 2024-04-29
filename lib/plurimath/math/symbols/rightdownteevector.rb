module Plurimath
  module Math
    module Symbols
      class Rightdownteevector < Symbol
        INPUT = {
          unicodemath: [["&#x295d;"], parsing_wrapper(["bardownharpoonright", "RightDownTeeVector"])],
          asciimath: [["&#x295d;"], parsing_wrapper(["bardownharpoonright", "RightDownTeeVector"])],
          mathml: ["&#x295d;"],
          latex: [["bardownharpoonright", "RightDownTeeVector", "&#x295d;"]],
          omml: ["&#x295d;"],
          html: ["&#x295d;"],
        }.freeze

        # output methods
        def to_latex
          "\\bardownharpoonright"
        end

        def to_asciimath
          parsing_wrapper("RightDownTeeVector")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x295d;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x295d;"
        end

        def to_omml_without_math_tag(_)
          "&#x295d;"
        end

        def to_html
          "&#x295d;"
        end
      end
    end
  end
end
