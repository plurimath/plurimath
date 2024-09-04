module Plurimath
  module Math
    module Symbols
      class Measuredangleleft < Symbol
        INPUT = {
          unicodemath: [["&#x299b;"], parsing_wrapper(["measuredangleleft"], lang: :unicode)],
          asciimath: [["&#x299b;"], parsing_wrapper(["measuredangleleft"], lang: :asciimath)],
          mathml: ["&#x299b;"],
          latex: [["measuredangleleft", "&#x299b;"]],
          omml: ["&#x299b;"],
          html: ["&#x299b;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\measuredangleleft"
        end

        def to_asciimath(**)
          parsing_wrapper("measuredangleleft", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x299b;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x299b;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x299b;"
        end

        def to_html(**)
          "&#x299b;"
        end
      end
    end
  end
end
