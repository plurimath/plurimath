module Plurimath
  module Math
    module Symbols
      class Sadface < Symbol
        INPUT = {
          unicodemath: [["&#x2639;"], parsing_wrapper(["frownie", "sadface"], lang: :unicode)],
          asciimath: [["&#x2639;"], parsing_wrapper(["frownie", "sadface"], lang: :asciimath)],
          mathml: ["&#x2639;"],
          latex: [["frownie", "sadface", "&#x2639;"]],
          omml: ["&#x2639;"],
          html: ["&#x2639;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\frownie"
        end

        def to_asciimath(**)
          parsing_wrapper("sadface", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2639;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2639;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2639;"
        end

        def to_html(**)
          "&#x2639;"
        end
      end
    end
  end
end
