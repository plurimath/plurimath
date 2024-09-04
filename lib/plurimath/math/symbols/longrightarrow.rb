module Plurimath
  module Math
    module Symbols
      class Longrightarrow < Symbol
        INPUT = {
          unicodemath: [["Longrightarrow", "&#x27f9;"], parsing_wrapper(["implies"], lang: :unicode)],
          asciimath: [["&#x27f9;"], parsing_wrapper(["Longrightarrow", "implies"], lang: :asciimath)],
          mathml: ["&#x27f9;"],
          latex: [["Longrightarrow", "implies", "&#x27f9;"]],
          omml: ["&#x27f9;"],
          html: ["&#x27f9;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\Longrightarrow"
        end

        def to_asciimath(**)
          parsing_wrapper("Longrightarrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x27f9;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x27f9;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x27f9;"
        end

        def to_html(**)
          "&#x27f9;"
        end
      end
    end
  end
end
