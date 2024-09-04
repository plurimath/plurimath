module Plurimath
  module Math
    module Symbols
      class Lat < Symbol
        INPUT = {
          unicodemath: [["&#x2aab;"], parsing_wrapper(["lat"], lang: :unicode)],
          asciimath: [["&#x2aab;"], parsing_wrapper(["lat"], lang: :asciimath)],
          mathml: ["&#x2aab;"],
          latex: [["lat", "&#x2aab;"]],
          omml: ["&#x2aab;"],
          html: ["&#x2aab;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\lat"
        end

        def to_asciimath(**)
          parsing_wrapper("lat", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2aab;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2aab;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2aab;"
        end

        def to_html(**)
          "&#x2aab;"
        end
      end
    end
  end
end
