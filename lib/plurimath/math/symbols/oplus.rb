module Plurimath
  module Math
    module Symbols
      class Oplus < Symbol
        INPUT = {
          unicodemath: [["oplus", "&#x2295;"], parsing_wrapper(["o+"], lang: :unicode)],
          asciimath: [["oplus", "o+", "&#x2295;"]],
          mathml: ["&#x2295;"],
          latex: [["oplus", "&#x2295;"], parsing_wrapper(["o+"], lang: :latex)],
          omml: ["&#x2295;"],
          html: ["&#x2295;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\oplus"
        end

        def to_asciimath(**)
          "oplus"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2295;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2295;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2295;"
        end

        def to_html(**)
          "&#x2295;"
        end
      end
    end
  end
end
