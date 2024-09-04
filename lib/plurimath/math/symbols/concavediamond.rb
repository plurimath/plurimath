module Plurimath
  module Math
    module Symbols
      class Concavediamond < Symbol
        INPUT = {
          unicodemath: [["&#x27e1;"], parsing_wrapper(["concavediamond"], lang: :unicode)],
          asciimath: [["&#x27e1;"], parsing_wrapper(["concavediamond"], lang: :asciimath)],
          mathml: ["&#x27e1;"],
          latex: [["concavediamond", "&#x27e1;"]],
          omml: ["&#x27e1;"],
          html: ["&#x27e1;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\concavediamond"
        end

        def to_asciimath(**)
          parsing_wrapper("concavediamond", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x27e1;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x27e1;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x27e1;"
        end

        def to_html(**)
          "&#x27e1;"
        end
      end
    end
  end
end
