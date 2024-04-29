module Plurimath
  module Math
    module Symbols
      class Rightwavearrow < Symbol
        INPUT = {
          unicodemath: [["rightwavearrow", "&#x219d;"]],
          asciimath: [["&#x219d;"], parsing_wrapper(["rightwavearrow"])],
          mathml: ["&#x219d;"],
          latex: [["rightwavearrow", "&#x219d;"]],
          omml: ["&#x219d;"],
          html: ["&#x219d;"],
        }.freeze

        # output methods
        def to_latex
          "\\rightwavearrow"
        end

        def to_asciimath
          parsing_wrapper("rightwavearrow")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x219d;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x219d;"
        end

        def to_omml_without_math_tag(_)
          "&#x219d;"
        end

        def to_html
          "&#x219d;"
        end
      end
    end
  end
end
