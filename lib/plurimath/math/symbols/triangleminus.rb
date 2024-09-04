module Plurimath
  module Math
    module Symbols
      class Triangleminus < Symbol
        INPUT = {
          unicodemath: [["&#x2a3a;"], parsing_wrapper(["triangleminus"], lang: :unicode)],
          asciimath: [["&#x2a3a;"], parsing_wrapper(["triangleminus"], lang: :asciimath)],
          mathml: ["&#x2a3a;"],
          latex: [["triangleminus", "&#x2a3a;"]],
          omml: ["&#x2a3a;"],
          html: ["&#x2a3a;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\triangleminus"
        end

        def to_asciimath(**)
          parsing_wrapper("triangleminus", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a3a;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a3a;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a3a;"
        end

        def to_html(**)
          "&#x2a3a;"
        end
      end
    end
  end
end
