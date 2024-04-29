module Plurimath
  module Math
    module Symbols
      class Barcup < Symbol
        INPUT = {
          unicodemath: [["&#x2a42;"], parsing_wrapper(["barcup"])],
          asciimath: [["&#x2a42;"], parsing_wrapper(["barcup"])],
          mathml: ["&#x2a42;"],
          latex: [["barcup", "&#x2a42;"]],
          omml: ["&#x2a42;"],
          html: ["&#x2a42;"],
        }.freeze

        # output methods
        def to_latex
          "\\barcup"
        end

        def to_asciimath
          parsing_wrapper("barcup")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2a42;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x2a42;"
        end

        def to_omml_without_math_tag(_)
          "&#x2a42;"
        end

        def to_html
          "&#x2a42;"
        end
      end
    end
  end
end
