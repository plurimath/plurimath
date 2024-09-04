module Plurimath
  module Math
    module Symbols
      class Leftcurvedarrow < Symbol
        INPUT = {
          unicodemath: [["&#x2b3f;"], parsing_wrapper(["leftcurvedarrow"], lang: :unicode)],
          asciimath: [["&#x2b3f;"], parsing_wrapper(["leftcurvedarrow"], lang: :asciimath)],
          mathml: ["&#x2b3f;"],
          latex: [["leftcurvedarrow", "&#x2b3f;"]],
          omml: ["&#x2b3f;"],
          html: ["&#x2b3f;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\leftcurvedarrow"
        end

        def to_asciimath(**)
          parsing_wrapper("leftcurvedarrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2b3f;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2b3f;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2b3f;"
        end

        def to_html(**)
          "&#x2b3f;"
        end
      end
    end
  end
end
