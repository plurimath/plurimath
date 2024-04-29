module Plurimath
  module Math
    module Symbols
      class Downharpoonright < Symbol
        INPUT = {
          unicodemath: [["downharpoonright", "&#x21c2;"], parsing_wrapper(["upharpoonrightdown"])],
          asciimath: [["&#x21c2;"], parsing_wrapper(["downharpoonright", "upharpoonrightdown"])],
          mathml: ["&#x21c2;"],
          latex: [["upharpoonrightdown", "downharpoonright", "&#x21c2;"]],
          omml: ["&#x21c2;"],
          html: ["&#x21c2;"],
        }.freeze

        # output methods
        def to_latex
          "\\upharpoonrightdown"
        end

        def to_asciimath
          parsing_wrapper("downharpoonright")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x21c2;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x21c2;"
        end

        def to_omml_without_math_tag(_)
          "&#x21c2;"
        end

        def to_html
          "&#x21c2;"
        end
      end
    end
  end
end
