module Plurimath
  module Math
    module Symbols
      class Nvleftarrow < Symbol
        INPUT = {
          unicodemath: [["&#x2902;"], parsing_wrapper(["nvLeftarrow"])],
          asciimath: [["&#x2902;"], parsing_wrapper(["nvLeftarrow"])],
          mathml: ["&#x2902;"],
          latex: [["nvLeftarrow", "&#x2902;"]],
          omml: ["&#x2902;"],
          html: ["&#x2902;"],
        }.freeze

        # output methods
        def to_latex
          "\\nvLeftarrow"
        end

        def to_asciimath
          parsing_wrapper("nvLeftarrow")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2902;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x2902;"
        end

        def to_omml_without_math_tag(_)
          "&#x2902;"
        end

        def to_html
          "&#x2902;"
        end
      end
    end
  end
end
