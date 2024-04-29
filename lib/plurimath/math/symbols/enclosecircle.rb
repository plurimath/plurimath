module Plurimath
  module Math
    module Symbols
      class Enclosecircle < Symbol
        INPUT = {
          unicodemath: [["&#x20dd;"], parsing_wrapper(["enclosecircle"])],
          asciimath: [["&#x20dd;"], parsing_wrapper(["enclosecircle"])],
          mathml: ["&#x20dd;"],
          latex: [["enclosecircle", "&#x20dd;"]],
          omml: ["&#x20dd;"],
          html: ["&#x20dd;"],
        }.freeze

        # output methods
        def to_latex
          "\\enclosecircle"
        end

        def to_asciimath
          parsing_wrapper("enclosecircle")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x20dd;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x20dd;"
        end

        def to_omml_without_math_tag(_)
          "&#x20dd;"
        end

        def to_html
          "&#x20dd;"
        end
      end
    end
  end
end
