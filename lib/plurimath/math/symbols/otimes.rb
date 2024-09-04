module Plurimath
  module Math
    module Symbols
      class Otimes < Symbol
        INPUT = {
          unicodemath: [["&#x2a37;"], parsing_wrapper(["Otimes"], lang: :unicode)],
          asciimath: [["&#x2a37;"], parsing_wrapper(["Otimes"], lang: :asciimath)],
          mathml: ["&#x2a37;"],
          latex: [["Otimes", "&#x2a37;"]],
          omml: ["&#x2a37;"],
          html: ["&#x2a37;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\Otimes"
        end

        def to_asciimath(**)
          parsing_wrapper("Otimes", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a37;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a37;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a37;"
        end

        def to_html(**)
          "&#x2a37;"
        end
      end
    end
  end
end
