module Plurimath
  module Math
    module Symbols
      class Tosa < Symbol
        INPUT = {
          unicodemath: [["&#x2929;"], parsing_wrapper(["tosa"], lang: :unicode)],
          asciimath: [["&#x2929;"], parsing_wrapper(["tosa"], lang: :asciimath)],
          mathml: ["&#x2929;"],
          latex: [["tosa", "&#x2929;"]],
          omml: ["&#x2929;"],
          html: ["&#x2929;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\tosa"
        end

        def to_asciimath(**)
          parsing_wrapper("tosa", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2929;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2929;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2929;"
        end

        def to_html(**)
          "&#x2929;"
        end
      end
    end
  end
end
