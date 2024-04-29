module Plurimath
  module Math
    module Symbols
      class Wedgeodot < Symbol
        INPUT = {
          unicodemath: [["&#x2a51;"], parsing_wrapper(["wedgeodot"])],
          asciimath: [["&#x2a51;"], parsing_wrapper(["wedgeodot"])],
          mathml: ["&#x2a51;"],
          latex: [["wedgeodot", "&#x2a51;"]],
          omml: ["&#x2a51;"],
          html: ["&#x2a51;"],
        }.freeze

        # output methods
        def to_latex
          "\\wedgeodot"
        end

        def to_asciimath
          parsing_wrapper("wedgeodot")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2a51;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x2a51;"
        end

        def to_omml_without_math_tag(_)
          "&#x2a51;"
        end

        def to_html
          "&#x2a51;"
        end
      end
    end
  end
end
