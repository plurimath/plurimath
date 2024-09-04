module Plurimath
  module Math
    module Symbols
      class Leftarrowplus < Symbol
        INPUT = {
          unicodemath: [["&#x2946;"], parsing_wrapper(["leftarrowplus"], lang: :unicode)],
          asciimath: [["&#x2946;"], parsing_wrapper(["leftarrowplus"], lang: :asciimath)],
          mathml: ["&#x2946;"],
          latex: [["leftarrowplus", "&#x2946;"]],
          omml: ["&#x2946;"],
          html: ["&#x2946;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\leftarrowplus"
        end

        def to_asciimath(**)
          parsing_wrapper("leftarrowplus", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2946;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2946;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2946;"
        end

        def to_html(**)
          "&#x2946;"
        end
      end
    end
  end
end
