module Plurimath
  module Math
    module Symbols
      class Cirscir < Symbol
        INPUT = {
          unicodemath: [["&#x29c2;"], parsing_wrapper(["cirscir"], lang: :unicode)],
          asciimath: [["&#x29c2;"], parsing_wrapper(["cirscir"], lang: :asciimath)],
          mathml: ["&#x29c2;"],
          latex: [["cirscir", "&#x29c2;"]],
          omml: ["&#x29c2;"],
          html: ["&#x29c2;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\cirscir"
        end

        def to_asciimath(**)
          parsing_wrapper("cirscir", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x29c2;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x29c2;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x29c2;"
        end

        def to_html(**)
          "&#x29c2;"
        end
      end
    end
  end
end
