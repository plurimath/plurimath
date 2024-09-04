module Plurimath
  module Math
    module Symbols
      class Beth < Symbol
        INPUT = {
          unicodemath: [["beth", "&#x2136;"]],
          asciimath: [["&#x2136;"], parsing_wrapper(["beth"], lang: :asciimath)],
          mathml: ["&#x2136;"],
          latex: [["beth", "&#x2136;"]],
          omml: ["&#x2136;"],
          html: ["&#x2136;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\beth"
        end

        def to_asciimath(**)
          parsing_wrapper("beth", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2136;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2136;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2136;"
        end

        def to_html(**)
          "&#x2136;"
        end
      end
    end
  end
end
