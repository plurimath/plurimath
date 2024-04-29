module Plurimath
  module Math
    module Symbols
      class Ringplus < Symbol
        INPUT = {
          unicodemath: [["&#x2a22;"], parsing_wrapper(["ringplus"])],
          asciimath: [["&#x2a22;"], parsing_wrapper(["ringplus"])],
          mathml: ["&#x2a22;"],
          latex: [["ringplus", "&#x2a22;"]],
          omml: ["&#x2a22;"],
          html: ["&#x2a22;"],
        }.freeze

        # output methods
        def to_latex
          "\\ringplus"
        end

        def to_asciimath
          parsing_wrapper("ringplus")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2a22;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x2a22;"
        end

        def to_omml_without_math_tag(_)
          "&#x2a22;"
        end

        def to_html
          "&#x2a22;"
        end
      end
    end
  end
end
