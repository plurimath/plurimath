module Plurimath
  module Math
    module Symbols
      class Psur < Symbol
        INPUT = {
          unicodemath: [["&#x2900;"], parsing_wrapper(["nvtwoheadrightarrow", "psurj", "psur"], lang: :unicode)],
          asciimath: [["&#x2900;"], parsing_wrapper(["nvtwoheadrightarrow", "psurj", "psur"], lang: :asciimath)],
          mathml: ["&#x2900;"],
          latex: [["nvtwoheadrightarrow", "psurj", "psur", "&#x2900;"]],
          omml: ["&#x2900;"],
          html: ["&#x2900;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\nvtwoheadrightarrow"
        end

        def to_asciimath(**)
          parsing_wrapper("psur", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2900;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2900;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2900;"
        end

        def to_html(**)
          "&#x2900;"
        end
      end
    end
  end
end
