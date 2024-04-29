module Plurimath
  module Math
    module Symbols
      class Ltcir < Symbol
        INPUT = {
          unicodemath: [["&#x2a79;"], parsing_wrapper(["ltcir"])],
          asciimath: [["&#x2a79;"], parsing_wrapper(["ltcir"])],
          mathml: ["&#x2a79;"],
          latex: [["ltcir", "&#x2a79;"]],
          omml: ["&#x2a79;"],
          html: ["&#x2a79;"],
        }.freeze

        # output methods
        def to_latex
          "\\ltcir"
        end

        def to_asciimath
          parsing_wrapper("ltcir")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2a79;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x2a79;"
        end

        def to_omml_without_math_tag(_)
          "&#x2a79;"
        end

        def to_html
          "&#x2a79;"
        end
      end
    end
  end
end
