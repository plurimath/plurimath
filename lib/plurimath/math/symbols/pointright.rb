module Plurimath
  module Math
    module Symbols
      class Pointright < Symbol
        INPUT = {
          unicodemath: [["&#x261e;"], parsing_wrapper(["pointright"])],
          asciimath: [["&#x261e;"], parsing_wrapper(["pointright"])],
          mathml: ["&#x261e;"],
          latex: [["pointright", "&#x261e;"]],
          omml: ["&#x261e;"],
          html: ["&#x261e;"],
        }.freeze

        # output methods
        def to_latex
          "\\pointright"
        end

        def to_asciimath
          parsing_wrapper("pointright")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x261e;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x261e;"
        end

        def to_omml_without_math_tag(_)
          "&#x261e;"
        end

        def to_html
          "&#x261e;"
        end
      end
    end
  end
end
