module Plurimath
  module Math
    module Symbols
      class Oeq < Symbol
        INPUT = {
          unicodemath: [["oeq", "&#x229c;"], parsing_wrapper(["circledequal"])],
          asciimath: [["&#x229c;"], parsing_wrapper(["oeq", "circledequal"])],
          mathml: ["&#x229c;"],
          latex: [["circledequal", "&#x229c;"], parsing_wrapper(["oeq"])],
          omml: ["&#x229c;"],
          html: ["&#x229c;"],
        }.freeze

        # output methods
        def to_latex
          "\\circledequal"
        end

        def to_asciimath
          parsing_wrapper("oeq")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x229c;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x229c;"
        end

        def to_omml_without_math_tag(_)
          "&#x229c;"
        end

        def to_html
          "&#x229c;"
        end
      end
    end
  end
end
