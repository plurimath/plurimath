module Plurimath
  module Math
    module Symbols
      class Medblackstar < Symbol
        INPUT = {
          unicodemath: [["&#x2b51;"], parsing_wrapper(["medblackstar"], lang: :unicode)],
          asciimath: [["&#x2b51;"], parsing_wrapper(["medblackstar"], lang: :asciimath)],
          mathml: ["&#x2b51;"],
          latex: [["medblackstar", "&#x2b51;"]],
          omml: ["&#x2b51;"],
          html: ["&#x2b51;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\medblackstar"
        end

        def to_asciimath(**)
          parsing_wrapper("medblackstar", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2b51;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2b51;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2b51;"
        end

        def to_html(**)
          "&#x2b51;"
        end
      end
    end
  end
end
