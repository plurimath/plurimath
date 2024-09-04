module Plurimath
  module Math
    module Symbols
      class Longleftrightarrow < Symbol
        INPUT = {
          unicodemath: [["Longleftrightarrow", "&#x27fa;"], parsing_wrapper(["iff"], lang: :unicode)],
          asciimath: [["&#x27fa;"], parsing_wrapper(["Longleftrightarrow", "iff"], lang: :asciimath)],
          mathml: ["&#x27fa;"],
          latex: [["Longleftrightarrow", "iff", "&#x27fa;"]],
          omml: ["&#x27fa;"],
          html: ["&#x27fa;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\Longleftrightarrow"
        end

        def to_asciimath(**)
          parsing_wrapper("Longleftrightarrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x27fa;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x27fa;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x27fa;"
        end

        def to_html(**)
          "&#x27fa;"
        end
      end
    end
  end
end
