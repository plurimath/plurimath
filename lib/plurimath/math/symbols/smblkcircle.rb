module Plurimath
  module Math
    module Symbols
      class Smblkcircle < Symbol
        INPUT = {
          unicodemath: [["&#x2022;"], parsing_wrapper(["smblkcircle", "bullet"], lang: :unicode)],
          asciimath: [["&#x2022;"], parsing_wrapper(["smblkcircle", "bullet"], lang: :asciimath)],
          mathml: ["&#x2022;"],
          latex: [["smblkcircle", "bullet", "&#x2022;"]],
          omml: ["&#x2022;"],
          html: ["&#x2022;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\smblkcircle"
        end

        def to_asciimath(**)
          parsing_wrapper("smblkcircle", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2022;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2022;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2022;"
        end

        def to_html(**)
          "&#x2022;"
        end
      end
    end
  end
end
