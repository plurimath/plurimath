module Plurimath
  module Math
    module Symbols
      class Nvleftrightarrow < Symbol
        INPUT = {
          unicodemath: [["&#x2904;"], parsing_wrapper(["nvLeftrightarrow"], lang: :unicode)],
          asciimath: [["&#x2904;"], parsing_wrapper(["nvLeftrightarrow"], lang: :asciimath)],
          mathml: ["&#x2904;"],
          latex: [["nvLeftrightarrow", "&#x2904;"]],
          omml: ["&#x2904;"],
          html: ["&#x2904;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\nvLeftrightarrow"
        end

        def to_asciimath(**)
          parsing_wrapper("nvLeftrightarrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2904;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2904;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2904;"
        end

        def to_html(**)
          "&#x2904;"
        end
      end
    end
  end
end
