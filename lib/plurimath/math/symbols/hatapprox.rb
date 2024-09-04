module Plurimath
  module Math
    module Symbols
      class Hatapprox < Symbol
        INPUT = {
          unicodemath: [["&#x2a6f;"], parsing_wrapper(["hatapprox"], lang: :unicode)],
          asciimath: [["&#x2a6f;"], parsing_wrapper(["hatapprox"], lang: :asciimath)],
          mathml: ["&#x2a6f;"],
          latex: [["hatapprox", "&#x2a6f;"]],
          omml: ["&#x2a6f;"],
          html: ["&#x2a6f;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\hatapprox"
        end

        def to_asciimath(**)
          parsing_wrapper("hatapprox", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a6f;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a6f;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a6f;"
        end

        def to_html(**)
          "&#x2a6f;"
        end
      end
    end
  end
end
