module Plurimath
  module Math
    module Symbols
      class Circledstar < Symbol
        INPUT = {
          unicodemath: [["&#x272a;"], parsing_wrapper(["circledstar"], lang: :unicode)],
          asciimath: [["&#x272a;"], parsing_wrapper(["circledstar"], lang: :asciimath)],
          mathml: ["&#x272a;"],
          latex: [["circledstar", "&#x272a;"]],
          omml: ["&#x272a;"],
          html: ["&#x272a;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\circledstar"
        end

        def to_asciimath(**)
          parsing_wrapper("circledstar", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x272a;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x272a;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x272a;"
        end

        def to_html(**)
          "&#x272a;"
        end
      end
    end
  end
end
