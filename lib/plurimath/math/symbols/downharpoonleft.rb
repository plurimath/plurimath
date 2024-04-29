module Plurimath
  module Math
    module Symbols
      class Downharpoonleft < Symbol
        INPUT = {
          unicodemath: [["downharpoonleft", "&#x21c3;"], parsing_wrapper(["upharpoonleftdown"])],
          asciimath: [["&#x21c3;"], parsing_wrapper(["downharpoonleft", "upharpoonleftdown"])],
          mathml: ["&#x21c3;"],
          latex: [["upharpoonleftdown", "downharpoonleft", "&#x21c3;"]],
          omml: ["&#x21c3;"],
          html: ["&#x21c3;"],
        }.freeze

        # output methods
        def to_latex
          "\\upharpoonleftdown"
        end

        def to_asciimath
          parsing_wrapper("downharpoonleft")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x21c3;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x21c3;"
        end

        def to_omml_without_math_tag(_)
          "&#x21c3;"
        end

        def to_html
          "&#x21c3;"
        end
      end
    end
  end
end
