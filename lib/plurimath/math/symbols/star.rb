module Plurimath
  module Math
    module Symbols
      class Star < Symbol
        INPUT = {
          unicodemath: [["star", "&#x22c6;"], parsing_wrapper(["***"], lang: :unicode)],
          asciimath: [["***", "star", "&#x22c6;"]],
          mathml: ["&#x22c6;"],
          latex: [["star", "&#x22c6;"], parsing_wrapper(["***"], lang: :latex)],
          omml: ["&#x22c6;"],
          html: ["&#x22c6;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\star"
        end

        def to_asciimath(**)
          "***"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22c6;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22c6;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22c6;"
        end

        def to_html(**)
          "&#x22c6;"
        end
      end
    end
  end
end
