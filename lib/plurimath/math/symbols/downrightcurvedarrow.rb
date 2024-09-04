module Plurimath
  module Math
    module Symbols
      class Downrightcurvedarrow < Symbol
        INPUT = {
          unicodemath: [["&#x2935;"], parsing_wrapper(["downrightcurvedarrow"], lang: :unicode)],
          asciimath: [["&#x2935;"], parsing_wrapper(["downrightcurvedarrow"], lang: :asciimath)],
          mathml: ["&#x2935;"],
          latex: [["downrightcurvedarrow", "&#x2935;"]],
          omml: ["&#x2935;"],
          html: ["&#x2935;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\downrightcurvedarrow"
        end

        def to_asciimath(**)
          parsing_wrapper("downrightcurvedarrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2935;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2935;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2935;"
        end

        def to_html(**)
          "&#x2935;"
        end
      end
    end
  end
end
