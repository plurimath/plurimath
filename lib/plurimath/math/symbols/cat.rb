module Plurimath
  module Math
    module Symbols
      class Cat < Symbol
        INPUT = {
          unicodemath: [["&#x2040;"], parsing_wrapper(["tieconcat", "cat"])],
          asciimath: [["&#x2040;"], parsing_wrapper(["tieconcat", "cat"])],
          mathml: ["&#x2040;"],
          latex: [["tieconcat", "cat", "&#x2040;"]],
          omml: ["&#x2040;"],
          html: ["&#x2040;"],
        }.freeze

        # output methods
        def to_latex
          "\\tieconcat"
        end

        def to_asciimath
          parsing_wrapper("cat")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2040;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x2040;"
        end

        def to_omml_without_math_tag(_)
          "&#x2040;"
        end

        def to_html
          "&#x2040;"
        end
      end
    end
  end
end
