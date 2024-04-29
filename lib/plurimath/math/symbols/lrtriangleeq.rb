module Plurimath
  module Math
    module Symbols
      class Lrtriangleeq < Symbol
        INPUT = {
          unicodemath: [["&#x29e1;"], parsing_wrapper(["lrtriangleeq"])],
          asciimath: [["&#x29e1;"], parsing_wrapper(["lrtriangleeq"])],
          mathml: ["&#x29e1;"],
          latex: [["lrtriangleeq", "&#x29e1;"]],
          omml: ["&#x29e1;"],
          html: ["&#x29e1;"],
        }.freeze

        # output methods
        def to_latex
          "\\lrtriangleeq"
        end

        def to_asciimath
          parsing_wrapper("lrtriangleeq")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x29e1;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x29e1;"
        end

        def to_omml_without_math_tag(_)
          "&#x29e1;"
        end

        def to_html
          "&#x29e1;"
        end
      end
    end
  end
end
