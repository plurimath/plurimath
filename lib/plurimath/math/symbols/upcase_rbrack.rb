module Plurimath
  module Math
    module Symbols
      class UpcaseRbrack < Symbol
        INPUT = {
          unicodemath: [["&#x27e7;"], parsing_wrapper(["rrbracket", "rBrack", "UpcaseRbrack"], lang: :unicode)],
          asciimath: [["&#x27e7;"], parsing_wrapper(["rrbracket", "rBrack", "UpcaseRbrack"], lang: :asciimath)],
          mathml: ["&#x27e7;"],
          latex: [["rrbracket", "rBrack", "Rbrack", "&#x27e7;"]],
          omml: ["&#x27e7;"],
          html: ["&#x27e7;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\rrbracket"
        end

        def to_asciimath(**)
          parsing_wrapper("Rbrack", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x27e7;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x27e7;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x27e7;"
        end

        def to_html(**)
          "&#x27e7;"
        end
      end
    end
  end
end
