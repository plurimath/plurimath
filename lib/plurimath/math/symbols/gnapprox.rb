module Plurimath
  module Math
    module Symbols
      class Gnapprox < Symbol
        INPUT = {
          unicodemath: [["&#x2a8a;"], parsing_wrapper(["gnapprox"], lang: :unicode)],
          asciimath: [["&#x2a8a;"], parsing_wrapper(["gnapprox"], lang: :asciimath)],
          mathml: ["&#x2a8a;"],
          latex: [["gnapprox", "&#x2a8a;"]],
          omml: ["&#x2a8a;"],
          html: ["&#x2a8a;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\gnapprox"
        end

        def to_asciimath(**)
          parsing_wrapper("gnapprox", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a8a;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a8a;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a8a;"
        end

        def to_html(**)
          "&#x2a8a;"
        end
      end
    end
  end
end
