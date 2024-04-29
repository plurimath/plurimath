module Plurimath
  module Math
    module Symbols
      class Rdiagovfdiag < Symbol
        INPUT = {
          unicodemath: [["&#x292b;"], parsing_wrapper(["rdiagovfdiag"])],
          asciimath: [["&#x292b;"], parsing_wrapper(["rdiagovfdiag"])],
          mathml: ["&#x292b;"],
          latex: [["rdiagovfdiag", "&#x292b;"]],
          omml: ["&#x292b;"],
          html: ["&#x292b;"],
        }.freeze

        # output methods
        def to_latex
          "\\rdiagovfdiag"
        end

        def to_asciimath
          parsing_wrapper("rdiagovfdiag")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x292b;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x292b;"
        end

        def to_omml_without_math_tag(_)
          "&#x292b;"
        end

        def to_html
          "&#x292b;"
        end
      end
    end
  end
end
