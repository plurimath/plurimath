module Plurimath
  module Math
    module Symbols
      class Leftdowncurvedarrow < Symbol
        INPUT = {
          unicodemath: [["&#x2936;"], parsing_wrapper(["leftdowncurvedarrow"], lang: :unicode)],
          asciimath: [["&#x2936;"], parsing_wrapper(["leftdowncurvedarrow"], lang: :asciimath)],
          mathml: ["&#x2936;"],
          latex: [["leftdowncurvedarrow", "&#x2936;"]],
          omml: ["&#x2936;"],
          html: ["&#x2936;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\leftdowncurvedarrow"
        end

        def to_asciimath(**)
          parsing_wrapper("leftdowncurvedarrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2936;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2936;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2936;"
        end

        def to_html(**)
          "&#x2936;"
        end
      end
    end
  end
end
