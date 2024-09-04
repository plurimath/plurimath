module Plurimath
  module Math
    module Symbols
      class Ngeq < Symbol
        INPUT = {
          unicodemath: [["ngeq", "&#x2271;"], parsing_wrapper(["ngeqslant"], lang: :unicode)],
          asciimath: [["&#x2271;"], parsing_wrapper(["ngeq", "ngeqslant"], lang: :asciimath)],
          mathml: ["&#x2271;"],
          latex: [["ngeqslant", "ngeq", "&#x2271;"]],
          omml: ["&#x2271;"],
          html: ["&#x2271;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\ngeqslant"
        end

        def to_asciimath(**)
          parsing_wrapper("ngeq", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2271;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2271;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2271;"
        end

        def to_html(**)
          "&#x2271;"
        end
      end
    end
  end
end
