module Plurimath
  module Math
    module Symbols
      class Sumint < Symbol
        INPUT = {
          unicodemath: [["&#x2a0b;"], parsing_wrapper(["sumint"], lang: :unicode)],
          asciimath: [["&#x2a0b;"], parsing_wrapper(["sumint"], lang: :asciimath)],
          mathml: ["&#x2a0b;"],
          latex: [["sumint", "&#x2a0b;"]],
          omml: ["&#x2a0b;"],
          html: ["&#x2a0b;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\sumint"
        end

        def to_asciimath(**)
          parsing_wrapper("sumint", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a0b;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a0b;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a0b;"
        end

        def to_html(**)
          "&#x2a0b;"
        end
      end
    end
  end
end
