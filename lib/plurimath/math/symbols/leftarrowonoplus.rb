module Plurimath
  module Math
    module Symbols
      class Leftarrowonoplus < Symbol
        INPUT = {
          unicodemath: [["&#x2b32;"], parsing_wrapper(["leftarrowonoplus"], lang: :unicode)],
          asciimath: [["&#x2b32;"], parsing_wrapper(["leftarrowonoplus"], lang: :asciimath)],
          mathml: ["&#x2b32;"],
          latex: [["leftarrowonoplus", "&#x2b32;"]],
          omml: ["&#x2b32;"],
          html: ["&#x2b32;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\leftarrowonoplus"
        end

        def to_asciimath(**)
          parsing_wrapper("leftarrowonoplus", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2b32;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2b32;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2b32;"
        end

        def to_html(**)
          "&#x2b32;"
        end
      end
    end
  end
end
