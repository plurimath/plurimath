module Plurimath
  module Math
    module Symbols
      class Gggnest < Symbol
        INPUT = {
          unicodemath: [["&#x2af8;"], parsing_wrapper(["gggnest"])],
          asciimath: [["&#x2af8;"], parsing_wrapper(["gggnest"])],
          mathml: ["&#x2af8;"],
          latex: [["gggnest", "&#x2af8;"]],
          omml: ["&#x2af8;"],
          html: ["&#x2af8;"],
        }.freeze

        # output methods
        def to_latex
          "\\gggnest"
        end

        def to_asciimath
          parsing_wrapper("gggnest")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2af8;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x2af8;"
        end

        def to_omml_without_math_tag(_)
          "&#x2af8;"
        end

        def to_html
          "&#x2af8;"
        end
      end
    end
  end
end
