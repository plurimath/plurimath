module Plurimath
  module Math
    module Symbols
      class Boxminus < Symbol
        INPUT = {
          unicodemath: [["boxminus", "&#x229f;"]],
          asciimath: [["&#x229f;"], parsing_wrapper(["boxminus"])],
          mathml: ["&#x229f;"],
          latex: [["boxminus", "&#x229f;"]],
          omml: ["&#x229f;"],
          html: ["&#x229f;"],
        }.freeze

        # output methods
        def to_latex
          "\\boxminus"
        end

        def to_asciimath
          parsing_wrapper("boxminus")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x229f;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x229f;"
        end

        def to_omml_without_math_tag(_)
          "&#x229f;"
        end

        def to_html
          "&#x229f;"
        end
      end
    end
  end
end
