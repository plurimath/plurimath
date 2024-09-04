module Plurimath
  module Math
    module Symbols
      class Measanglerutone < Symbol
        INPUT = {
          unicodemath: [["&#x29a8;"], parsing_wrapper(["measanglerutone"], lang: :unicode)],
          asciimath: [["&#x29a8;"], parsing_wrapper(["measanglerutone"], lang: :asciimath)],
          mathml: ["&#x29a8;"],
          latex: [["measanglerutone", "&#x29a8;"]],
          omml: ["&#x29a8;"],
          html: ["&#x29a8;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\measanglerutone"
        end

        def to_asciimath(**)
          parsing_wrapper("measanglerutone", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x29a8;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x29a8;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x29a8;"
        end

        def to_html(**)
          "&#x29a8;"
        end
      end
    end
  end
end
