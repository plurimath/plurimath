module Plurimath
  module Math
    module Symbols
      class Whiteinwhitetriangle < Symbol
        INPUT = {
          unicodemath: [["&#x27c1;"], parsing_wrapper(["whiteinwhitetriangle"], lang: :unicode)],
          asciimath: [["&#x27c1;"], parsing_wrapper(["whiteinwhitetriangle"], lang: :asciimath)],
          mathml: ["&#x27c1;"],
          latex: [["whiteinwhitetriangle", "&#x27c1;"]],
          omml: ["&#x27c1;"],
          html: ["&#x27c1;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\whiteinwhitetriangle"
        end

        def to_asciimath(**)
          parsing_wrapper("whiteinwhitetriangle", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x27c1;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x27c1;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x27c1;"
        end

        def to_html(**)
          "&#x27c1;"
        end
      end
    end
  end
end
