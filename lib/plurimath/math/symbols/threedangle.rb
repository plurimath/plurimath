module Plurimath
  module Math
    module Symbols
      class Threedangle < Symbol
        INPUT = {
          unicodemath: [["&#x27c0;"], parsing_wrapper(["threedangle"], lang: :unicode)],
          asciimath: [["&#x27c0;"], parsing_wrapper(["threedangle"], lang: :asciimath)],
          mathml: ["&#x27c0;"],
          latex: [["threedangle", "&#x27c0;"]],
          omml: ["&#x27c0;"],
          html: ["&#x27c0;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\threedangle"
        end

        def to_asciimath(**)
          parsing_wrapper("threedangle", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x27c0;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x27c0;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x27c0;"
        end

        def to_html(**)
          "&#x27c0;"
        end
      end
    end
  end
end
