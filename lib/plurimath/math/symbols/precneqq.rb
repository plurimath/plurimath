module Plurimath
  module Math
    module Symbols
      class Precneqq < Symbol
        INPUT = {
          unicodemath: [["&#x2ab5;"], parsing_wrapper(["precneqq"])],
          asciimath: [["&#x2ab5;"], parsing_wrapper(["precneqq"])],
          mathml: ["&#x2ab5;"],
          latex: [["precneqq", "&#x2ab5;"]],
          omml: ["&#x2ab5;"],
          html: ["&#x2ab5;"],
        }.freeze

        # output methods
        def to_latex
          "\\precneqq"
        end

        def to_asciimath
          parsing_wrapper("precneqq")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2ab5;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x2ab5;"
        end

        def to_omml_without_math_tag(_)
          "&#x2ab5;"
        end

        def to_html
          "&#x2ab5;"
        end
      end
    end
  end
end
