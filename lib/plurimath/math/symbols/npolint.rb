module Plurimath
  module Math
    module Symbols
      class Npolint < Symbol
        INPUT = {
          unicodemath: [["&#x2a14;"], parsing_wrapper(["npolint"], lang: :unicode)],
          asciimath: [["&#x2a14;"], parsing_wrapper(["npolint"], lang: :asciimath)],
          mathml: ["&#x2a14;"],
          latex: [["npolint", "&#x2a14;"]],
          omml: ["&#x2a14;"],
          html: ["&#x2a14;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\npolint"
        end

        def to_asciimath(**)
          parsing_wrapper("npolint", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a14;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a14;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a14;"
        end

        def to_html(**)
          "&#x2a14;"
        end
      end
    end
  end
end
