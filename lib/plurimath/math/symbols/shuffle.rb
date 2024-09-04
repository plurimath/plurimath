module Plurimath
  module Math
    module Symbols
      class Shuffle < Symbol
        INPUT = {
          unicodemath: [["&#x29e2;"], parsing_wrapper(["shuffle"], lang: :unicode)],
          asciimath: [["&#x29e2;"], parsing_wrapper(["shuffle"], lang: :asciimath)],
          mathml: ["&#x29e2;"],
          latex: [["shuffle", "&#x29e2;"]],
          omml: ["&#x29e2;"],
          html: ["&#x29e2;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\shuffle"
        end

        def to_asciimath(**)
          parsing_wrapper("shuffle", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x29e2;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x29e2;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x29e2;"
        end

        def to_html(**)
          "&#x29e2;"
        end
      end
    end
  end
end
