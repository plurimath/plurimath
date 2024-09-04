module Plurimath
  module Math
    module Symbols
      class Otimeslhrim < Symbol
        INPUT = {
          unicodemath: [["&#x2a34;"], parsing_wrapper(["otimeslhrim"], lang: :unicode)],
          asciimath: [["&#x2a34;"], parsing_wrapper(["otimeslhrim"], lang: :asciimath)],
          mathml: ["&#x2a34;"],
          latex: [["otimeslhrim", "&#x2a34;"]],
          omml: ["&#x2a34;"],
          html: ["&#x2a34;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\otimeslhrim"
        end

        def to_asciimath(**)
          parsing_wrapper("otimeslhrim", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a34;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a34;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a34;"
        end

        def to_html(**)
          "&#x2a34;"
        end
      end
    end
  end
end
