module Plurimath
  module Math
    module Symbols
      class UpcaseOmega < Symbol
        INPUT = {
          unicodemath: [["&#x3a9;"], parsing_wrapper(["UpcaseOmega", "UpcaseupOmega"], lang: :unicode)],
          asciimath: [["Omega", "&#x3a9;"], parsing_wrapper(["upOmega"], lang: :asciimath)],
          mathml: ["&#x3a9;"],
          latex: [["upOmega", "Omega", "&#x3a9;"]],
          omml: ["&#x3a9;"],
          html: ["&#x3a9;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\Omega"
        end

        def to_asciimath(**)
          "Omega"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x3a9;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x3a9;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x3a9;"
        end

        def to_html(**)
          "&#x3a9;"
        end
      end
    end
  end
end
