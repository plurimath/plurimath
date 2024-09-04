module Plurimath
  module Math
    module Symbols
      class Leftdotarrow < Symbol
        INPUT = {
          unicodemath: [["&#x2b38;"], parsing_wrapper(["leftdotarrow"], lang: :unicode)],
          asciimath: [["&#x2b38;"], parsing_wrapper(["leftdotarrow"], lang: :asciimath)],
          mathml: ["&#x2b38;"],
          latex: [["leftdotarrow", "&#x2b38;"]],
          omml: ["&#x2b38;"],
          html: ["&#x2b38;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\leftdotarrow"
        end

        def to_asciimath(**)
          parsing_wrapper("leftdotarrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2b38;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2b38;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2b38;"
        end

        def to_html(**)
          "&#x2b38;"
        end
      end
    end
  end
end
