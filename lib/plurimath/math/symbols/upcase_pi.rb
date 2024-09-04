module Plurimath
  module Math
    module Symbols
      class UpcasePi < Symbol
        INPUT = {
          unicodemath: [["Pi", "&#x3a0;"], parsing_wrapper(["upPi"], lang: :unicode)],
          asciimath: [["Pi", "&#x3a0;"], parsing_wrapper(["upPi"], lang: :asciimath)],
          mathml: ["&#x3a0;"],
          latex: [["upPi", "Pi", "&#x3a0;"]],
          omml: ["&#x3a0;"],
          html: ["&#x3a0;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\Pi"
        end

        def to_asciimath(**)
          "Pi"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x3a0;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x3a0;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x3a0;"
        end

        def to_html(**)
          "&#x3a0;"
        end
      end
    end
  end
end
