module Plurimath
  module Math
    module Symbols
      class Dualmap < Symbol
        INPUT = {
          unicodemath: [["&#x29df;"], parsing_wrapper(["multimapboth", "dualmap"], lang: :unicode)],
          asciimath: [["&#x29df;"], parsing_wrapper(["multimapboth", "dualmap"], lang: :asciimath)],
          mathml: ["&#x29df;"],
          latex: [["multimapboth", "dualmap", "&#x29df;"]],
          omml: ["&#x29df;"],
          html: ["&#x29df;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\multimapboth"
        end

        def to_asciimath(**)
          parsing_wrapper("dualmap", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x29df;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x29df;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x29df;"
        end

        def to_html(**)
          "&#x29df;"
        end
      end
    end
  end
end
