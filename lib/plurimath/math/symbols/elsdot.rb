module Plurimath
  module Math
    module Symbols
      class Elsdot < Symbol
        INPUT = {
          unicodemath: [["&#x2a97;"], parsing_wrapper(["elsdot"], lang: :unicode)],
          asciimath: [["&#x2a97;"], parsing_wrapper(["elsdot"], lang: :asciimath)],
          mathml: ["&#x2a97;"],
          latex: [["elsdot", "&#x2a97;"]],
          omml: ["&#x2a97;"],
          html: ["&#x2a97;"],
        }.freeze

        # output methods
        def to_latex
          "\\elsdot"
        end

        def to_asciimath
          parsing_wrapper("elsdot", lang: :asciimath)
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2a97;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a97;"
        end

        def to_omml_without_math_tag(_)
          "&#x2a97;"
        end

        def to_html
          "&#x2a97;"
        end
      end
    end
  end
end
