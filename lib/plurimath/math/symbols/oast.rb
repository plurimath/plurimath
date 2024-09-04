module Plurimath
  module Math
    module Symbols
      class Oast < Symbol
        INPUT = {
          unicodemath: [["oast", "&#x229b;"], parsing_wrapper(["circledast"], lang: :unicode)],
          asciimath: [["&#x229b;"], parsing_wrapper(["oast", "circledast"], lang: :asciimath)],
          mathml: ["&#x229b;"],
          latex: [["circledast", "&#x229b;"], parsing_wrapper(["oast"], lang: :latex)],
          omml: ["&#x229b;"],
          html: ["&#x229b;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\circledast"
        end

        def to_asciimath(**)
          parsing_wrapper("oast", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x229b;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x229b;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x229b;"
        end

        def to_html(**)
          "&#x229b;"
        end
      end
    end
  end
end
