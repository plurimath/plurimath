module Plurimath
  module Math
    module Symbols
      class Geq < Symbol
        INPUT = {
          unicodemath: [["ge", "geq", "&#x2265;"], parsing_wrapper([">="])],
          asciimath: [[">=", "ge", "&#x2265;"], parsing_wrapper(["geq"])],
          mathml: ["&#x2265;"],
          latex: [["geq", "ge", "&#x2265;"], parsing_wrapper([">="])],
          omml: ["&#x2265;"],
          html: ["&#x2265;"],
        }.freeze

        # output methods
        def to_latex
          "\\geq"
        end

        def to_asciimath
          ">="
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2265;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x2265;"
        end

        def to_omml_without_math_tag(_)
          "&#x2265;"
        end

        def to_html
          "&#x2265;"
        end
      end
    end
  end
end
