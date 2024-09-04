module Plurimath
  module Math
    module Symbols
      class Similarrightarrow < Symbol
        INPUT = {
          unicodemath: [["&#x2972;"], parsing_wrapper(["similarrightarrow"], lang: :unicode)],
          asciimath: [["&#x2972;"], parsing_wrapper(["similarrightarrow"], lang: :asciimath)],
          mathml: ["&#x2972;"],
          latex: [["similarrightarrow", "&#x2972;"]],
          omml: ["&#x2972;"],
          html: ["&#x2972;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\similarrightarrow"
        end

        def to_asciimath(**)
          parsing_wrapper("similarrightarrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2972;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2972;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2972;"
        end

        def to_html(**)
          "&#x2972;"
        end
      end
    end
  end
end
