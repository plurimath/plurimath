module Plurimath
  module Math
    module Symbols
      class Supsetcirc < Symbol
        INPUT = {
          unicodemath: [["&#x27c4;"], parsing_wrapper(["supsetcirc"])],
          asciimath: [["&#x27c4;"], parsing_wrapper(["supsetcirc"])],
          mathml: ["&#x27c4;"],
          latex: [["supsetcirc", "&#x27c4;"]],
          omml: ["&#x27c4;"],
          html: ["&#x27c4;"],
        }.freeze

        # output methods
        def to_latex
          "\\supsetcirc"
        end

        def to_asciimath
          parsing_wrapper("supsetcirc")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x27c4;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x27c4;"
        end

        def to_omml_without_math_tag(_)
          "&#x27c4;"
        end

        def to_html
          "&#x27c4;"
        end
      end
    end
  end
end
