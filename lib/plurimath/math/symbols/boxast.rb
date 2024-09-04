module Plurimath
  module Math
    module Symbols
      class Boxast < Symbol
        INPUT = {
          unicodemath: [["&#x29c6;"], parsing_wrapper(["boxast"], lang: :unicode)],
          asciimath: [["&#x29c6;"], parsing_wrapper(["boxast"], lang: :asciimath)],
          mathml: ["&#x29c6;"],
          latex: [["boxast", "&#x29c6;"]],
          omml: ["&#x29c6;"],
          html: ["&#x29c6;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\boxast"
        end

        def to_asciimath(**)
          parsing_wrapper("boxast", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x29c6;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x29c6;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x29c6;"
        end

        def to_html(**)
          "&#x29c6;"
        end
      end
    end
  end
end
