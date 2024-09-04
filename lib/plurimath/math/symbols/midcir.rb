module Plurimath
  module Math
    module Symbols
      class Midcir < Symbol
        INPUT = {
          unicodemath: [["&#x2af0;"], parsing_wrapper(["midcir"], lang: :unicode)],
          asciimath: [["&#x2af0;"], parsing_wrapper(["midcir"], lang: :asciimath)],
          mathml: ["&#x2af0;"],
          latex: [["midcir", "&#x2af0;"]],
          omml: ["&#x2af0;"],
          html: ["&#x2af0;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\midcir"
        end

        def to_asciimath(**)
          parsing_wrapper("midcir", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2af0;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2af0;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2af0;"
        end

        def to_html(**)
          "&#x2af0;"
        end
      end
    end
  end
end
