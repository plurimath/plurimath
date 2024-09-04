module Plurimath
  module Math
    module Symbols
      class Dasharrow < Symbol
        INPUT = {
          unicodemath: [["&#x21e2;"], parsing_wrapper(["dashrightarrow", "rightdasharrow", "dasharrow"], lang: :unicode)],
          asciimath: [["&#x21e2;"], parsing_wrapper(["dashrightarrow", "rightdasharrow", "dasharrow"], lang: :asciimath)],
          mathml: ["&#x21e2;"],
          latex: [["dashrightarrow", "rightdasharrow", "dasharrow", "&#x21e2;"]],
          omml: ["&#x21e2;"],
          html: ["&#x21e2;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\dashrightarrow"
        end

        def to_asciimath(**)
          parsing_wrapper("dasharrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x21e2;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x21e2;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x21e2;"
        end

        def to_html(**)
          "&#x21e2;"
        end
      end
    end
  end
end
