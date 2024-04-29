module Plurimath
  module Math
    module Symbols
      class Cupdot < Symbol
        INPUT = {
          unicodemath: [["&#x228d;"], parsing_wrapper(["cupdot"])],
          asciimath: [["&#x228d;"], parsing_wrapper(["cupdot"])],
          mathml: ["&#x228d;"],
          latex: [["cupdot", "&#x228d;"]],
          omml: ["&#x228d;"],
          html: ["&#x228d;"],
        }.freeze

        # output methods
        def to_latex
          "\\cupdot"
        end

        def to_asciimath
          parsing_wrapper("cupdot")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x228d;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x228d;"
        end

        def to_omml_without_math_tag(_)
          "&#x228d;"
        end

        def to_html
          "&#x228d;"
        end
      end
    end
  end
end
