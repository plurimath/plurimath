module Plurimath
  module Math
    module Symbols
      class Leftarrow < Symbol
        INPUT = {
          unicodemath: [["Leftarrow", "&#x21d0;"], parsing_wrapper(["lArr"])],
          asciimath: [["Leftarrow", "lArr", "&#x21d0;"]],
          mathml: ["&#x21d0;"],
          latex: [["Leftarrow", "&#x21d0;"], parsing_wrapper(["lArr"])],
          omml: ["&#x21d0;"],
          html: ["&#x21d0;"],
        }.freeze

        # output methods
        def to_latex
          "\\Leftarrow"
        end

        def to_asciimath
          parsing_wrapper("Leftarrow")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x21d0;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x21d0;"
        end

        def to_omml_without_math_tag(_)
          "&#x21d0;"
        end

        def to_html
          "&#x21d0;"
        end
      end
    end
  end
end
