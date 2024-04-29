module Plurimath
  module Math
    module Symbols
      class Checkedbox < Symbol
        INPUT = {
          unicodemath: [["&#x2611;"], parsing_wrapper(["CheckedBox"])],
          asciimath: [["&#x2611;"], parsing_wrapper(["CheckedBox"])],
          mathml: ["&#x2611;"],
          latex: [["CheckedBox", "&#x2611;"]],
          omml: ["&#x2611;"],
          html: ["&#x2611;"],
        }.freeze

        # output methods
        def to_latex
          "\\CheckedBox"
        end

        def to_asciimath
          parsing_wrapper("CheckedBox")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2611;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x2611;"
        end

        def to_omml_without_math_tag(_)
          "&#x2611;"
        end

        def to_html
          "&#x2611;"
        end
      end
    end
  end
end
