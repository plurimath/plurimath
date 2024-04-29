module Plurimath
  module Math
    module Symbols
      class Xsol < Symbol
        INPUT = {
          unicodemath: [["&#x29f8;"], parsing_wrapper(["xsol"])],
          asciimath: [["&#x29f8;"], parsing_wrapper(["xsol"])],
          mathml: ["&#x29f8;"],
          latex: [["xsol", "&#x29f8;"]],
          omml: ["&#x29f8;"],
          html: ["&#x29f8;"],
        }.freeze

        # output methods
        def to_latex
          "\\xsol"
        end

        def to_asciimath
          parsing_wrapper("xsol")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x29f8;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x29f8;"
        end

        def to_omml_without_math_tag(_)
          "&#x29f8;"
        end

        def to_html
          "&#x29f8;"
        end
      end
    end
  end
end
