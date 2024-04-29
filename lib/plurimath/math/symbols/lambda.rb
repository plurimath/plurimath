module Plurimath
  module Math
    module Symbols
      class Lambda < Symbol
        INPUT = {
          unicodemath: [["lambda", "&#x3bb;"], parsing_wrapper(["uplambda"])],
          asciimath: [["lambda", "&#x3bb;"], parsing_wrapper(["uplambda"])],
          mathml: ["&#x3bb;"],
          latex: [["uplambda", "lambda", "&#x3bb;"]],
          omml: ["&#x3bb;"],
          html: ["&#x3bb;"],
        }.freeze

        # output methods
        def to_latex
          "\\lambda"
        end

        def to_asciimath
          "lambda"
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x3bb;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x3bb;"
        end

        def to_omml_without_math_tag(_)
          "&#x3bb;"
        end

        def to_html
          "&#x3bb;"
        end
      end
    end
  end
end
