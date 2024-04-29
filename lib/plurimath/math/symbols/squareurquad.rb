module Plurimath
  module Math
    module Symbols
      class Squareurquad < Symbol
        INPUT = {
          unicodemath: [["&#x25f3;"], parsing_wrapper(["squareurquad"])],
          asciimath: [["&#x25f3;"], parsing_wrapper(["squareurquad"])],
          mathml: ["&#x25f3;"],
          latex: [["squareurquad", "&#x25f3;"]],
          omml: ["&#x25f3;"],
          html: ["&#x25f3;"],
        }.freeze

        # output methods
        def to_latex
          "\\squareurquad"
        end

        def to_asciimath
          parsing_wrapper("squareurquad")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x25f3;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x25f3;"
        end

        def to_omml_without_math_tag(_)
          "&#x25f3;"
        end

        def to_html
          "&#x25f3;"
        end
      end
    end
  end
end
