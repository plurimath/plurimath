module Plurimath
  module Math
    module Symbols
      class UpcaseRightarrow < Symbol
        INPUT = {
          unicodemath: [["Rightarrow", "&#x21d2;"], parsing_wrapper(["implies", "rArr", "=>", "UpcaseRightarrow"], lang: :unicode)],
          asciimath: [["Rightarrow", "implies", "rArr", "=>", "&#x21d2;"], parsing_wrapper(["UpcaseRightarrow"], lang: :asciimath)],
          mathml: ["&#x21d2;"],
          latex: [["Rightarrow", "&#x21d2;"], parsing_wrapper(["implies", "rArr", "=>"], lang: :latex)],
          omml: ["&#x21d2;"],
          html: ["&#x21d2;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\Rightarrow"
        end

        def to_asciimath(**)
          "Rightarrow"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x21d2;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x21d2;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x21d2;"
        end

        def to_html(**)
          "&#x21d2;"
        end
      end
    end
  end
end
