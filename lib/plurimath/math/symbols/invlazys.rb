module Plurimath
  module Math
    module Symbols
      class Invlazys < Symbol
        INPUT = {
          unicodemath: [["&#x223e;"], parsing_wrapper(["invlazys"])],
          asciimath: [["&#x223e;"], parsing_wrapper(["invlazys"])],
          mathml: ["&#x223e;"],
          latex: [["invlazys", "&#x223e;"]],
          omml: ["&#x223e;"],
          html: ["&#x223e;"],
        }.freeze

        # output methods
        def to_latex
          "\\invlazys"
        end

        def to_asciimath
          parsing_wrapper("invlazys")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x223e;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x223e;"
        end

        def to_omml_without_math_tag(_)
          "&#x223e;"
        end

        def to_html
          "&#x223e;"
        end
      end
    end
  end
end
