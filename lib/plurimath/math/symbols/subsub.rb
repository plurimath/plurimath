module Plurimath
  module Math
    module Symbols
      class Subsub < Symbol
        INPUT = {
          unicodemath: [["subsub", "&#x2ad3;"], parsing_wrapper(["subsup"])],
          asciimath: [["&#x2ad3;"], parsing_wrapper(["subsub", "subsup"])],
          mathml: ["&#x2ad3;"],
          latex: [["subsup", "&#x2ad3;"], parsing_wrapper(["subsub"])],
          omml: ["&#x2ad3;"],
          html: ["&#x2ad3;"],
        }.freeze

        # output methods
        def to_latex
          "\\subsup"
        end

        def to_asciimath
          parsing_wrapper("subsub")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2ad3;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x2ad3;"
        end

        def to_omml_without_math_tag(_)
          "&#x2ad3;"
        end

        def to_html
          "&#x2ad3;"
        end
      end
    end
  end
end
