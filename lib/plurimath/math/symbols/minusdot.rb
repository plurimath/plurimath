module Plurimath
  module Math
    module Symbols
      class Minusdot < Symbol
        INPUT = {
          unicodemath: [["&#x2a2a;"], parsing_wrapper(["minusdot"], lang: :unicode)],
          asciimath: [["&#x2a2a;"], parsing_wrapper(["minusdot"], lang: :asciimath)],
          mathml: ["&#x2a2a;"],
          latex: [["minusdot", "&#x2a2a;"]],
          omml: ["&#x2a2a;"],
          html: ["&#x2a2a;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\minusdot"
        end

        def to_asciimath(**)
          parsing_wrapper("minusdot", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a2a;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a2a;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a2a;"
        end

        def to_html(**)
          "&#x2a2a;"
        end
      end
    end
  end
end
