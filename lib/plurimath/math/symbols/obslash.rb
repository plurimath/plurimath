module Plurimath
  module Math
    module Symbols
      class Obslash < Symbol
        INPUT = {
          unicodemath: [["&#x29b8;"], parsing_wrapper(["circledbslash", "obslash"], lang: :unicode)],
          asciimath: [["&#x29b8;"], parsing_wrapper(["circledbslash", "obslash"], lang: :asciimath)],
          mathml: ["&#x29b8;"],
          latex: [["circledbslash", "obslash", "&#x29b8;"]],
          omml: ["&#x29b8;"],
          html: ["&#x29b8;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\circledbslash"
        end

        def to_asciimath(**)
          parsing_wrapper("obslash", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x29b8;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x29b8;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x29b8;"
        end

        def to_html(**)
          "&#x29b8;"
        end
      end
    end
  end
end
