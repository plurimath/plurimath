module Plurimath
  module Math
    module Symbols
      class Btimes < Symbol
        INPUT = {
          unicodemath: [["&#x2a32;"], parsing_wrapper(["btimes"], lang: :unicode)],
          asciimath: [["&#x2a32;"], parsing_wrapper(["btimes"], lang: :asciimath)],
          mathml: ["&#x2a32;"],
          latex: [["btimes", "&#x2a32;"]],
          omml: ["&#x2a32;"],
          html: ["&#x2a32;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\btimes"
        end

        def to_asciimath(**)
          parsing_wrapper("btimes", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a32;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a32;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a32;"
        end

        def to_html(**)
          "&#x2a32;"
        end
      end
    end
  end
end
