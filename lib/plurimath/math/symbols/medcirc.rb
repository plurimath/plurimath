module Plurimath
  module Math
    module Symbols
      class Medcirc < Symbol
        INPUT = {
          unicodemath: [["&#x26aa;"], parsing_wrapper(["mdwhtcircle", "medcirc"], lang: :unicode)],
          asciimath: [["&#x26aa;"], parsing_wrapper(["mdwhtcircle", "medcirc"], lang: :asciimath)],
          mathml: ["&#x26aa;"],
          latex: [["mdwhtcircle", "medcirc", "&#x26aa;"]],
          omml: ["&#x26aa;"],
          html: ["&#x26aa;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\mdwhtcircle"
        end

        def to_asciimath(**)
          parsing_wrapper("medcirc", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x26aa;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x26aa;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x26aa;"
        end

        def to_html(**)
          "&#x26aa;"
        end
      end
    end
  end
end
