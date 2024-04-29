module Plurimath
  module Math
    module Symbols
      class Simminussim < Symbol
        INPUT = {
          unicodemath: [["&#x2a6c;"], parsing_wrapper(["simminussim"])],
          asciimath: [["&#x2a6c;"], parsing_wrapper(["simminussim"])],
          mathml: ["&#x2a6c;"],
          latex: [["simminussim", "&#x2a6c;"]],
          omml: ["&#x2a6c;"],
          html: ["&#x2a6c;"],
        }.freeze

        # output methods
        def to_latex
          "\\simminussim"
        end

        def to_asciimath
          parsing_wrapper("simminussim")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2a6c;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x2a6c;"
        end

        def to_omml_without_math_tag(_)
          "&#x2a6c;"
        end

        def to_html
          "&#x2a6c;"
        end
      end
    end
  end
end
