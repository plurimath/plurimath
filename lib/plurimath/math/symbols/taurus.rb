module Plurimath
  module Math
    module Symbols
      class Taurus < Symbol
        INPUT = {
          unicodemath: [["&#x2649;"], parsing_wrapper(["taurus", "Taurus"], lang: :unicode)],
          asciimath: [["&#x2649;"], parsing_wrapper(["taurus", "Taurus"], lang: :asciimath)],
          mathml: ["&#x2649;"],
          latex: [["taurus", "Taurus", "&#x2649;"]],
          omml: ["&#x2649;"],
          html: ["&#x2649;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\taurus"
        end

        def to_asciimath(**)
          parsing_wrapper("Taurus", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2649;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2649;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2649;"
        end

        def to_html(**)
          "&#x2649;"
        end
      end
    end
  end
end
