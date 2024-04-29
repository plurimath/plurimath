module Plurimath
  module Math
    module Symbols
      class Rbrbrak < Symbol
        INPUT = {
          unicodemath: [["&#x27ed;"], parsing_wrapper(["Rbrbrak"])],
          asciimath: [["&#x27ed;"], parsing_wrapper(["Rbrbrak"])],
          mathml: ["&#x27ed;"],
          latex: [["Rbrbrak", "&#x27ed;"]],
          omml: ["&#x27ed;"],
          html: ["&#x27ed;"],
        }.freeze

        # output methods
        def to_latex
          "\\Rbrbrak"
        end

        def to_asciimath
          parsing_wrapper("Rbrbrak")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x27ed;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x27ed;"
        end

        def to_omml_without_math_tag(_)
          "&#x27ed;"
        end

        def to_html
          "&#x27ed;"
        end
      end
    end
  end
end
