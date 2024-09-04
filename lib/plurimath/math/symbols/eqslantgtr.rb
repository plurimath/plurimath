module Plurimath
  module Math
    module Symbols
      class Eqslantgtr < Symbol
        INPUT = {
          unicodemath: [["&#x2a96;"], parsing_wrapper(["eqslantgtr"], lang: :unicode)],
          asciimath: [["&#x2a96;"], parsing_wrapper(["eqslantgtr"], lang: :asciimath)],
          mathml: ["&#x2a96;"],
          latex: [["eqslantgtr", "&#x2a96;"]],
          omml: ["&#x2a96;"],
          html: ["&#x2a96;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\eqslantgtr"
        end

        def to_asciimath(**)
          parsing_wrapper("eqslantgtr", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a96;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a96;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a96;"
        end

        def to_html(**)
          "&#x2a96;"
        end
      end
    end
  end
end
