module Plurimath
  module Math
    module Symbols
      class Odotslashdot < Symbol
        INPUT = {
          unicodemath: [["&#x29bc;"], parsing_wrapper(["odotslashdot"])],
          asciimath: [["&#x29bc;"], parsing_wrapper(["odotslashdot"])],
          mathml: ["&#x29bc;"],
          latex: [["odotslashdot", "&#x29bc;"]],
          omml: ["&#x29bc;"],
          html: ["&#x29bc;"],
        }.freeze

        # output methods
        def to_latex
          "\\odotslashdot"
        end

        def to_asciimath
          parsing_wrapper("odotslashdot")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x29bc;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x29bc;"
        end

        def to_omml_without_math_tag(_)
          "&#x29bc;"
        end

        def to_html
          "&#x29bc;"
        end
      end
    end
  end
end
