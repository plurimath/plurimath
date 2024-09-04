module Plurimath
  module Math
    module Symbols
      class Gtreqqless < Symbol
        INPUT = {
          unicodemath: [["&#x2a8c;"], parsing_wrapper(["gtreqqless"], lang: :unicode)],
          asciimath: [["&#x2a8c;"], parsing_wrapper(["gtreqqless"], lang: :asciimath)],
          mathml: ["&#x2a8c;"],
          latex: [["gtreqqless", "&#x2a8c;"]],
          omml: ["&#x2a8c;"],
          html: ["&#x2a8c;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\gtreqqless"
        end

        def to_asciimath(**)
          parsing_wrapper("gtreqqless", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a8c;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a8c;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a8c;"
        end

        def to_html(**)
          "&#x2a8c;"
        end
      end
    end
  end
end
