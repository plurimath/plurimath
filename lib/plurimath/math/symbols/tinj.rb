module Plurimath
  module Math
    module Symbols
      class Tinj < Symbol
        INPUT = {
          unicodemath: [["rightarrowtail", "&#x21a3;"], parsing_wrapper([">->", "tinj"])],
          asciimath: [["rightarrowtail", ">->", "&#x21a3;"], parsing_wrapper(["tinj"])],
          mathml: ["&#x21a3;"],
          latex: [["rightarrowtail", "tinj", "&#x21a3;"], parsing_wrapper([">->"])],
          omml: ["&#x21a3;"],
          html: ["&#x21a3;"],
        }.freeze

        # output methods
        def to_latex
          "\\rightarrowtail"
        end

        def to_asciimath
          parsing_wrapper("tinj")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x21a3;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x21a3;"
        end

        def to_omml_without_math_tag(_)
          "&#x21a3;"
        end

        def to_html
          "&#x21a3;"
        end
      end
    end
  end
end
