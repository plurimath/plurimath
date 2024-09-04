module Plurimath
  module Math
    module Symbols
      class Plussubtwo < Symbol
        INPUT = {
          unicodemath: [["&#x2a27;"], parsing_wrapper(["plussubtwo"], lang: :unicode)],
          asciimath: [["&#x2a27;"], parsing_wrapper(["plussubtwo"], lang: :asciimath)],
          mathml: ["&#x2a27;"],
          latex: [["plussubtwo", "&#x2a27;"]],
          omml: ["&#x2a27;"],
          html: ["&#x2a27;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\plussubtwo"
        end

        def to_asciimath(**)
          parsing_wrapper("plussubtwo", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a27;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a27;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a27;"
        end

        def to_html(**)
          "&#x2a27;"
        end
      end
    end
  end
end
