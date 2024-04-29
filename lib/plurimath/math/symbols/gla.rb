module Plurimath
  module Math
    module Symbols
      class Gla < Symbol
        INPUT = {
          unicodemath: [["&#x2aa5;"], parsing_wrapper(["gla"])],
          asciimath: [["&#x2aa5;"], parsing_wrapper(["gla"])],
          mathml: ["&#x2aa5;"],
          latex: [["gla", "&#x2aa5;"]],
          omml: ["&#x2aa5;"],
          html: ["&#x2aa5;"],
        }.freeze

        # output methods
        def to_latex
          "\\gla"
        end

        def to_asciimath
          parsing_wrapper("gla")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2aa5;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x2aa5;"
        end

        def to_omml_without_math_tag(_)
          "&#x2aa5;"
        end

        def to_html
          "&#x2aa5;"
        end
      end
    end
  end
end
