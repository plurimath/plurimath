module Plurimath
  module Math
    module Symbols
      class Downrightvectorbar < Symbol
        INPUT = {
          unicodemath: [["&#x2957;"], parsing_wrapper(["rightharpoondownbar", "DownRightVectorBar"], lang: :unicode)],
          asciimath: [["&#x2957;"], parsing_wrapper(["rightharpoondownbar", "DownRightVectorBar"], lang: :asciimath)],
          mathml: ["&#x2957;"],
          latex: [["rightharpoondownbar", "DownRightVectorBar", "&#x2957;"]],
          omml: ["&#x2957;"],
          html: ["&#x2957;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\rightharpoondownbar"
        end

        def to_asciimath(**)
          parsing_wrapper("DownRightVectorBar", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2957;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2957;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2957;"
        end

        def to_html(**)
          "&#x2957;"
        end
      end
    end
  end
end
