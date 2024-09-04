module Plurimath
  module Math
    module Symbols
      class Mp < Symbol
        INPUT = {
          unicodemath: [["mp", "&#x2213;"]],
          asciimath: [["&#x2213;"], parsing_wrapper(["mp"], lang: :asciimath)],
          mathml: ["&#x2213;"],
          latex: [["mp", "&#x2213;"]],
          omml: ["&#x2213;"],
          html: ["&#x2213;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\mp"
        end

        def to_asciimath(**)
          parsing_wrapper("mp", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2213;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2213;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2213;"
        end

        def to_html(**)
          "&#x2213;"
        end
      end
    end
  end
end
