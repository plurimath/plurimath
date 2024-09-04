module Plurimath
  module Math
    module Symbols
      class Circledvert < Symbol
        INPUT = {
          unicodemath: [["&#x29b6;"], parsing_wrapper(["circledvert"], lang: :unicode)],
          asciimath: [["&#x29b6;"], parsing_wrapper(["circledvert"], lang: :asciimath)],
          mathml: ["&#x29b6;"],
          latex: [["circledvert", "&#x29b6;"]],
          omml: ["&#x29b6;"],
          html: ["&#x29b6;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\circledvert"
        end

        def to_asciimath(**)
          parsing_wrapper("circledvert", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x29b6;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x29b6;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x29b6;"
        end

        def to_html(**)
          "&#x29b6;"
        end
      end
    end
  end
end
