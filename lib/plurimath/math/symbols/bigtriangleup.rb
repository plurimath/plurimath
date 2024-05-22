module Plurimath
  module Math
    module Symbols
      class Bigtriangleup < Symbol
        INPUT = {
          unicodemath: [["triangle", "&#x25b3;"], parsing_wrapper(["/_\\", "bigtriangleup"])],
          asciimath: [["triangle", "/_\\", "&#x25b3;"], parsing_wrapper(["bigtriangleup"])],
          mathml: ["&#x25b3;"],
          latex: [["bigtriangleup", "triangle", "&#x25b3;"], parsing_wrapper(["/_\\"])],
          omml: ["&#x25b3;"],
          html: ["&#x25b3;"],
        }.freeze

        # output methods
        def to_latex
          "\\bigtriangleup"
        end

        def to_asciimath
          "triangle"
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x25b3;")
        end

        def to_mathml_without_math_tag(_)
          ox_element("mi") << "&#x25b3;"
        end

        def to_omml_without_math_tag(_)
          "&#x25b3;"
        end

        def to_html
          "&#x25b3;"
        end
      end
    end
  end
end
