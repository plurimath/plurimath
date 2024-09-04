module Plurimath
  module Math
    module Symbols
      class Circlevertfill < Symbol
        INPUT = {
          unicodemath: [["&#x25cd;"], parsing_wrapper(["circlevertfill"], lang: :unicode)],
          asciimath: [["&#x25cd;"], parsing_wrapper(["circlevertfill"], lang: :asciimath)],
          mathml: ["&#x25cd;"],
          latex: [["circlevertfill", "&#x25cd;"]],
          omml: ["&#x25cd;"],
          html: ["&#x25cd;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\circlevertfill"
        end

        def to_asciimath(**)
          parsing_wrapper("circlevertfill", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25cd;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25cd;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25cd;"
        end

        def to_html(**)
          "&#x25cd;"
        end
      end
    end
  end
end
