module Plurimath
  module Math
    module Symbols
      class Strns < Symbol
        INPUT = {
          unicodemath: [["&#x23e4;"], parsing_wrapper(["strns"])],
          asciimath: [["&#x23e4;"], parsing_wrapper(["strns"])],
          mathml: ["&#x23e4;"],
          latex: [["strns", "&#x23e4;"]],
          omml: ["&#x23e4;"],
          html: ["&#x23e4;"],
        }.freeze

        # output methods
        def to_latex
          "\\strns"
        end

        def to_asciimath
          parsing_wrapper("strns")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x23e4;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x23e4;"
        end

        def to_omml_without_math_tag(_)
          "&#x23e4;"
        end

        def to_html
          "&#x23e4;"
        end
      end
    end
  end
end
