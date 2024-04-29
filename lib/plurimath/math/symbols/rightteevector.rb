module Plurimath
  module Math
    module Symbols
      class Rightteevector < Symbol
        INPUT = {
          unicodemath: [["&#x295b;"], parsing_wrapper(["barrightharpoonup", "RightTeeVector"])],
          asciimath: [["&#x295b;"], parsing_wrapper(["barrightharpoonup", "RightTeeVector"])],
          mathml: ["&#x295b;"],
          latex: [["barrightharpoonup", "RightTeeVector", "&#x295b;"]],
          omml: ["&#x295b;"],
          html: ["&#x295b;"],
        }.freeze

        # output methods
        def to_latex
          "\\barrightharpoonup"
        end

        def to_asciimath
          parsing_wrapper("RightTeeVector")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x295b;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x295b;"
        end

        def to_omml_without_math_tag(_)
          "&#x295b;"
        end

        def to_html
          "&#x295b;"
        end
      end
    end
  end
end
