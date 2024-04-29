module Plurimath
  module Math
    module Symbols
      class Circleurquadblack < Symbol
        INPUT = {
          unicodemath: [["&#x25d4;"], parsing_wrapper(["circleurquadblack"])],
          asciimath: [["&#x25d4;"], parsing_wrapper(["circleurquadblack"])],
          mathml: ["&#x25d4;"],
          latex: [["circleurquadblack", "&#x25d4;"]],
          omml: ["&#x25d4;"],
          html: ["&#x25d4;"],
        }.freeze

        # output methods
        def to_latex
          "\\circleurquadblack"
        end

        def to_asciimath
          parsing_wrapper("circleurquadblack")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x25d4;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x25d4;"
        end

        def to_omml_without_math_tag(_)
          "&#x25d4;"
        end

        def to_html
          "&#x25d4;"
        end
      end
    end
  end
end
