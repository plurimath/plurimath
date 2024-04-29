module Plurimath
  module Math
    module Symbols
      class Updownarrows < Symbol
        INPUT = {
          unicodemath: [["updownarrows", "&#x21c5;"], parsing_wrapper(["uparrowdownarrow"])],
          asciimath: [["&#x21c5;"], parsing_wrapper(["updownarrows", "uparrowdownarrow"])],
          mathml: ["&#x21c5;"],
          latex: [["uparrowdownarrow", "updownarrows", "&#x21c5;"]],
          omml: ["&#x21c5;"],
          html: ["&#x21c5;"],
        }.freeze

        # output methods
        def to_latex
          "\\uparrowdownarrow"
        end

        def to_asciimath
          parsing_wrapper("updownarrows")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x21c5;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x21c5;"
        end

        def to_omml_without_math_tag(_)
          "&#x21c5;"
        end

        def to_html
          "&#x21c5;"
        end
      end
    end
  end
end
