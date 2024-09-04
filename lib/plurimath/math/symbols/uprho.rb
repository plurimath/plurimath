module Plurimath
  module Math
    module Symbols
      class Uprho < Symbol
        INPUT = {
          unicodemath: [["&#x3a1;"], parsing_wrapper(["upRho"], lang: :unicode)],
          asciimath: [["&#x3a1;"], parsing_wrapper(["upRho"], lang: :asciimath)],
          mathml: ["&#x3a1;"],
          latex: [["upRho", "&#x3a1;"]],
          omml: ["&#x3a1;"],
          html: ["&#x3a1;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\upRho"
        end

        def to_asciimath(**)
          parsing_wrapper("upRho", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x3a1;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x3a1;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x3a1;"
        end

        def to_html(**)
          "&#x3a1;"
        end
      end
    end
  end
end
