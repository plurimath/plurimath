module Plurimath
  module Math
    module Symbols
      class Invwhitelowerhalfcircle < Symbol
        INPUT = {
          unicodemath: [["&#x25db;"], parsing_wrapper(["invwhitelowerhalfcircle"])],
          asciimath: [["&#x25db;"], parsing_wrapper(["invwhitelowerhalfcircle"])],
          mathml: ["&#x25db;"],
          latex: [["invwhitelowerhalfcircle", "&#x25db;"]],
          omml: ["&#x25db;"],
          html: ["&#x25db;"],
        }.freeze

        # output methods
        def to_latex
          "\\invwhitelowerhalfcircle"
        end

        def to_asciimath
          parsing_wrapper("invwhitelowerhalfcircle")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x25db;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x25db;"
        end

        def to_omml_without_math_tag(_)
          "&#x25db;"
        end

        def to_html
          "&#x25db;"
        end
      end
    end
  end
end
