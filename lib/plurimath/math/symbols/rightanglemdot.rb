module Plurimath
  module Math
    module Symbols
      class Rightanglemdot < Symbol
        INPUT = {
          unicodemath: [["&#x299d;"], parsing_wrapper(["rightanglemdot"])],
          asciimath: [["&#x299d;"], parsing_wrapper(["rightanglemdot"])],
          mathml: ["&#x299d;"],
          latex: [["rightanglemdot", "&#x299d;"]],
          omml: ["&#x299d;"],
          html: ["&#x299d;"],
        }.freeze

        # output methods
        def to_latex
          "\\rightanglemdot"
        end

        def to_asciimath
          parsing_wrapper("rightanglemdot")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x299d;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x299d;"
        end

        def to_omml_without_math_tag(_)
          "&#x299d;"
        end

        def to_html
          "&#x299d;"
        end
      end
    end
  end
end
