module Plurimath
  module Math
    module Symbols
      class Cupovercap < Symbol
        INPUT = {
          unicodemath: [["&#x2a46;"], parsing_wrapper(["cupovercap"], lang: :unicode)],
          asciimath: [["&#x2a46;"], parsing_wrapper(["cupovercap"], lang: :asciimath)],
          mathml: ["&#x2a46;"],
          latex: [["cupovercap", "&#x2a46;"]],
          omml: ["&#x2a46;"],
          html: ["&#x2a46;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\cupovercap"
        end

        def to_asciimath(**)
          parsing_wrapper("cupovercap", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a46;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a46;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a46;"
        end

        def to_html(**)
          "&#x2a46;"
        end
      end
    end
  end
end
