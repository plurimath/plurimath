module Plurimath
  module Math
    module Symbols
      class Venus < Symbol
        INPUT = {
          unicodemath: [["&#x2640;"], parsing_wrapper(["female", "Venus"], lang: :unicode)],
          asciimath: [["&#x2640;"], parsing_wrapper(["female", "Venus"], lang: :asciimath)],
          mathml: ["&#x2640;"],
          latex: [["female", "Venus", "&#x2640;"]],
          omml: ["&#x2640;"],
          html: ["&#x2640;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\female"
        end

        def to_asciimath(**)
          parsing_wrapper("Venus", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2640;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2640;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2640;"
        end

        def to_html(**)
          "&#x2640;"
        end
      end
    end
  end
end
