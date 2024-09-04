module Plurimath
  module Math
    module Symbols
      class Wp < Symbol
        INPUT = {
          unicodemath: [["wp", "&#x2118;"]],
          asciimath: [["&#x2118;"], parsing_wrapper(["wp"], lang: :asciimath)],
          mathml: ["&#x2118;"],
          latex: [["wp", "&#x2118;"]],
          omml: ["&#x2118;"],
          html: ["&#x2118;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\wp"
        end

        def to_asciimath(**)
          parsing_wrapper("wp", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2118;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2118;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2118;"
        end

        def to_html(**)
          "&#x2118;"
        end
      end
    end
  end
end
