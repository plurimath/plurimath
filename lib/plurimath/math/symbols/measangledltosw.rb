module Plurimath
  module Math
    module Symbols
      class Measangledltosw < Symbol
        INPUT = {
          unicodemath: [["&#x29af;"], parsing_wrapper(["measangledltosw"])],
          asciimath: [["&#x29af;"], parsing_wrapper(["measangledltosw"])],
          mathml: ["&#x29af;"],
          latex: [["measangledltosw", "&#x29af;"]],
          omml: ["&#x29af;"],
          html: ["&#x29af;"],
        }.freeze

        # output methods
        def to_latex
          "\\measangledltosw"
        end

        def to_asciimath
          parsing_wrapper("measangledltosw")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x29af;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x29af;"
        end

        def to_omml_without_math_tag(_)
          "&#x29af;"
        end

        def to_html
          "&#x29af;"
        end
      end
    end
  end
end
