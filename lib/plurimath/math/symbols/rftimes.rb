module Plurimath
  module Math
    module Symbols
      class Rftimes < Symbol
        INPUT = {
          unicodemath: [["&#x29d5;"], parsing_wrapper(["rftimes"])],
          asciimath: [["&#x29d5;"], parsing_wrapper(["rftimes"])],
          mathml: ["&#x29d5;"],
          latex: [["rftimes", "&#x29d5;"]],
          omml: ["&#x29d5;"],
          html: ["&#x29d5;"],
        }.freeze

        # output methods
        def to_latex
          "\\rftimes"
        end

        def to_asciimath
          parsing_wrapper("rftimes")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x29d5;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x29d5;"
        end

        def to_omml_without_math_tag(_)
          "&#x29d5;"
        end

        def to_html
          "&#x29d5;"
        end
      end
    end
  end
end
