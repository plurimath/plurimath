module Plurimath
  module Math
    module Symbols
      class Scpolint < Symbol
        INPUT = {
          unicodemath: [["&#x2a13;"], parsing_wrapper(["scpolint"], lang: :unicode)],
          asciimath: [["&#x2a13;"], parsing_wrapper(["scpolint"], lang: :asciimath)],
          mathml: ["&#x2a13;"],
          latex: [["scpolint", "&#x2a13;"]],
          omml: ["&#x2a13;"],
          html: ["&#x2a13;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\scpolint"
        end

        def to_asciimath(**)
          parsing_wrapper("scpolint", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a13;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a13;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a13;"
        end

        def to_html(**)
          "&#x2a13;"
        end
      end
    end
  end
end
