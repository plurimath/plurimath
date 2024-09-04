module Plurimath
  module Math
    module Symbols
      class Eqslantless < Symbol
        INPUT = {
          unicodemath: [["&#x2a95;"], parsing_wrapper(["eqslantless"], lang: :unicode)],
          asciimath: [["&#x2a95;"], parsing_wrapper(["eqslantless"], lang: :asciimath)],
          mathml: ["&#x2a95;"],
          latex: [["eqslantless", "&#x2a95;"]],
          omml: ["&#x2a95;"],
          html: ["&#x2a95;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\eqslantless"
        end

        def to_asciimath(**)
          parsing_wrapper("eqslantless", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a95;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a95;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a95;"
        end

        def to_html(**)
          "&#x2a95;"
        end
      end
    end
  end
end
