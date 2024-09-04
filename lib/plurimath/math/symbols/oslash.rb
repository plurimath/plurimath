module Plurimath
  module Math
    module Symbols
      class Oslash < Symbol
        INPUT = {
          unicodemath: [["&#x2298;"], parsing_wrapper(["oslash"], lang: :unicode)],
          asciimath: [["&#x2298;"], parsing_wrapper(["oslash"], lang: :asciimath)],
          mathml: ["&#x2298;"],
          latex: [["oslash", "&#x2298;"]],
          omml: ["&#x2298;"],
          html: ["&#x2298;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\oslash"
        end

        def to_asciimath(**)
          parsing_wrapper("oslash", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2298;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2298;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2298;"
        end

        def to_html(**)
          "&#x2298;"
        end
      end
    end
  end
end
