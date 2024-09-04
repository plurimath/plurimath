module Plurimath
  module Math
    module Symbols
      class Circle < Symbol
        INPUT = {
          unicodemath: [["&#x25cf;"], parsing_wrapper(["mdlgblkcircle", "CIRCLE"], lang: :unicode)],
          asciimath: [["&#x25cf;"], parsing_wrapper(["mdlgblkcircle", "CIRCLE"], lang: :asciimath)],
          mathml: ["&#x25cf;"],
          latex: [["mdlgblkcircle", "CIRCLE", "&#x25cf;"]],
          omml: ["&#x25cf;"],
          html: ["&#x25cf;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\mdlgblkcircle"
        end

        def to_asciimath(**)
          parsing_wrapper("CIRCLE", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25cf;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25cf;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25cf;"
        end

        def to_html(**)
          "&#x25cf;"
        end
      end
    end
  end
end
