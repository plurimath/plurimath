module Plurimath
  module Math
    module Symbols
      class Circledparallel < Symbol
        INPUT = {
          unicodemath: [["&#x29b7;"], parsing_wrapper(["circledparallel"])],
          asciimath: [["&#x29b7;"], parsing_wrapper(["circledparallel"])],
          mathml: ["&#x29b7;"],
          latex: [["circledparallel", "&#x29b7;"]],
          omml: ["&#x29b7;"],
          html: ["&#x29b7;"],
        }.freeze

        # output methods
        def to_latex
          "\\circledparallel"
        end

        def to_asciimath
          parsing_wrapper("circledparallel")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x29b7;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x29b7;"
        end

        def to_omml_without_math_tag(_)
          "&#x29b7;"
        end

        def to_html
          "&#x29b7;"
        end
      end
    end
  end
end
