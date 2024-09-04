module Plurimath
  module Math
    module Symbols
      class Succapprox < Symbol
        INPUT = {
          unicodemath: [["&#x2ab8;"], parsing_wrapper(["succapprox"], lang: :unicode)],
          asciimath: [["&#x2ab8;"], parsing_wrapper(["succapprox"], lang: :asciimath)],
          mathml: ["&#x2ab8;"],
          latex: [["succapprox", "&#x2ab8;"]],
          omml: ["&#x2ab8;"],
          html: ["&#x2ab8;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\succapprox"
        end

        def to_asciimath(**)
          parsing_wrapper("succapprox", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2ab8;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2ab8;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2ab8;"
        end

        def to_html(**)
          "&#x2ab8;"
        end
      end
    end
  end
end
