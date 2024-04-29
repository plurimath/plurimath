module Plurimath
  module Math
    module Symbols
      class Vec < Symbol
        INPUT = {
          unicodemath: [["&#x20d7;"], parsing_wrapper(["Vec"])],
          asciimath: [["&#x20d7;"], parsing_wrapper(["Vec"])],
          mathml: ["&#x20d7;"],
          latex: [["Vec", "&#x20d7;"]],
          omml: ["&#x20d7;"],
          html: ["&#x20d7;"],
        }.freeze

        # output methods
        def to_latex
          "\\Vec"
        end

        def to_asciimath
          parsing_wrapper("Vec")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x20d7;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x20d7;"
        end

        def to_omml_without_math_tag(_)
          "&#x20d7;"
        end

        def to_html
          "&#x20d7;"
        end
      end
    end
  end
end
