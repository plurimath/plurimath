module Plurimath
  module Math
    module Symbols
      class Precsim < Symbol
        INPUT = {
          unicodemath: [["precsim", "&#x227e;"], parsing_wrapper(["PrecedesTilde"], lang: :unicode)],
          asciimath: [["&#x227e;"], parsing_wrapper(["precsim", "PrecedesTilde"], lang: :asciimath)],
          mathml: ["&#x227e;"],
          latex: [["PrecedesTilde", "precsim", "&#x227e;"]],
          omml: ["&#x227e;"],
          html: ["&#x227e;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\PrecedesTilde"
        end

        def to_asciimath(**)
          parsing_wrapper("precsim", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x227e;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x227e;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x227e;"
        end

        def to_html(**)
          "&#x227e;"
        end
      end
    end
  end
end
