module Plurimath
  module Math
    module Symbols
      class Backprime < Symbol
        INPUT = {
          unicodemath: [["&#x2035;"], parsing_wrapper(["backprime"], lang: :unicode)],
          asciimath: [["&#x2035;"], parsing_wrapper(["backprime"], lang: :asciimath)],
          mathml: ["&#x2035;"],
          latex: [["backprime", "&#x2035;"]],
          omml: ["&#x2035;"],
          html: ["&#x2035;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\backprime"
        end

        def to_asciimath(**)
          parsing_wrapper("backprime", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2035;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2035;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2035;"
        end

        def to_html(**)
          "&#x2035;"
        end
      end
    end
  end
end
