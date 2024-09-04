module Plurimath
  module Math
    module Symbols
      class Hermaphrodite < Symbol
        INPUT = {
          unicodemath: [["&#x26a5;"], parsing_wrapper(["Hermaphrodite"], lang: :unicode)],
          asciimath: [["&#x26a5;"], parsing_wrapper(["Hermaphrodite"], lang: :asciimath)],
          mathml: ["&#x26a5;"],
          latex: [["Hermaphrodite", "&#x26a5;"]],
          omml: ["&#x26a5;"],
          html: ["&#x26a5;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\Hermaphrodite"
        end

        def to_asciimath(**)
          parsing_wrapper("Hermaphrodite", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x26a5;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x26a5;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x26a5;"
        end

        def to_html(**)
          "&#x26a5;"
        end
      end
    end
  end
end
