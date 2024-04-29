module Plurimath
  module Math
    module Symbols
      class Same < Symbol
        INPUT = {
          unicodemath: [["&#x2a76;"], parsing_wrapper(["eqeqeq", "Same"])],
          asciimath: [["&#x2a76;"], parsing_wrapper(["eqeqeq", "Same"])],
          mathml: ["&#x2a76;"],
          latex: [["eqeqeq", "Same", "&#x2a76;"]],
          omml: ["&#x2a76;"],
          html: ["&#x2a76;"],
        }.freeze

        # output methods
        def to_latex
          "\\eqeqeq"
        end

        def to_asciimath
          parsing_wrapper("Same")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2a76;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x2a76;"
        end

        def to_omml_without_math_tag(_)
          "&#x2a76;"
        end

        def to_html
          "&#x2a76;"
        end
      end
    end
  end
end
