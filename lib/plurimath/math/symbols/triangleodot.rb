module Plurimath
  module Math
    module Symbols
      class Triangleodot < Symbol
        INPUT = {
          unicodemath: [["&#x29ca;"], parsing_wrapper(["triangleodot"], lang: :unicode)],
          asciimath: [["&#x29ca;"], parsing_wrapper(["triangleodot"], lang: :asciimath)],
          mathml: ["&#x29ca;"],
          latex: [["triangleodot", "&#x29ca;"]],
          omml: ["&#x29ca;"],
          html: ["&#x29ca;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\triangleodot"
        end

        def to_asciimath(**)
          parsing_wrapper("triangleodot", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x29ca;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x29ca;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x29ca;"
        end

        def to_html(**)
          "&#x29ca;"
        end
      end
    end
  end
end
