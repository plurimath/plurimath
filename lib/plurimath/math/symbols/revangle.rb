module Plurimath
  module Math
    module Symbols
      class Revangle < Symbol
        INPUT = {
          unicodemath: [["&#x29a3;"], parsing_wrapper(["revangle"])],
          asciimath: [["&#x29a3;"], parsing_wrapper(["revangle"])],
          mathml: ["&#x29a3;"],
          latex: [["revangle", "&#x29a3;"]],
          omml: ["&#x29a3;"],
          html: ["&#x29a3;"],
        }.freeze

        # output methods
        def to_latex
          "\\revangle"
        end

        def to_asciimath
          parsing_wrapper("revangle")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x29a3;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x29a3;"
        end

        def to_omml_without_math_tag(_)
          "&#x29a3;"
        end

        def to_html
          "&#x29a3;"
        end
      end
    end
  end
end
