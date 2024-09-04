module Plurimath
  module Math
    module Symbols
      class Upzeta < Symbol
        INPUT = {
          unicodemath: [["&#x396;"], parsing_wrapper(["upZeta"], lang: :unicode)],
          asciimath: [["&#x396;"], parsing_wrapper(["upZeta"], lang: :asciimath)],
          mathml: ["&#x396;"],
          latex: [["upZeta", "&#x396;"]],
          omml: ["&#x396;"],
          html: ["&#x396;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\upZeta"
        end

        def to_asciimath(**)
          parsing_wrapper("upZeta", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x396;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x396;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x396;"
        end

        def to_html(**)
          "&#x396;"
        end
      end
    end
  end
end
