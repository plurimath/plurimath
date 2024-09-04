module Plurimath
  module Math
    module Symbols
      class Multimapinv < Symbol
        INPUT = {
          unicodemath: [["&#x27dc;"], parsing_wrapper(["multimapinv"], lang: :unicode)],
          asciimath: [["&#x27dc;"], parsing_wrapper(["multimapinv"], lang: :asciimath)],
          mathml: ["&#x27dc;"],
          latex: [["multimapinv", "&#x27dc;"]],
          omml: ["&#x27dc;"],
          html: ["&#x27dc;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\multimapinv"
        end

        def to_asciimath(**)
          parsing_wrapper("multimapinv", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x27dc;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x27dc;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x27dc;"
        end

        def to_html(**)
          "&#x27dc;"
        end
      end
    end
  end
end
