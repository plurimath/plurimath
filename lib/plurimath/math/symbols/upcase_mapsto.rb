module Plurimath
  module Math
    module Symbols
      class UpcaseMapsto < Symbol
        INPUT = {
          unicodemath: [["&#x2907;"], parsing_wrapper(["UpcaseMapsto"], lang: :unicode)],
          asciimath: [["&#x2907;"], parsing_wrapper(["UpcaseMapsto"], lang: :asciimath)],
          mathml: ["&#x2907;"],
          latex: [["Mapsto", "&#x2907;"]],
          omml: ["&#x2907;"],
          html: ["&#x2907;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\Mapsto"
        end

        def to_asciimath(**)
          parsing_wrapper("Mapsto", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2907;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2907;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2907;"
        end

        def to_html(**)
          "&#x2907;"
        end
      end
    end
  end
end
