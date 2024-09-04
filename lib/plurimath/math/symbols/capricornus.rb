module Plurimath
  module Math
    module Symbols
      class Capricornus < Symbol
        INPUT = {
          unicodemath: [["&#x2651;"], parsing_wrapper(["capricornus"], lang: :unicode)],
          asciimath: [["&#x2651;"], parsing_wrapper(["capricornus"], lang: :asciimath)],
          mathml: ["&#x2651;"],
          latex: [["capricornus", "&#x2651;"]],
          omml: ["&#x2651;"],
          html: ["&#x2651;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\capricornus"
        end

        def to_asciimath(**)
          parsing_wrapper("capricornus", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2651;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2651;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2651;"
        end

        def to_html(**)
          "&#x2651;"
        end
      end
    end
  end
end
