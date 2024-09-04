module Plurimath
  module Math
    module Symbols
      class Hermitmatrix < Symbol
        INPUT = {
          unicodemath: [["&#x22b9;"], parsing_wrapper(["hermitmatrix"], lang: :unicode)],
          asciimath: [["&#x22b9;"], parsing_wrapper(["hermitmatrix"], lang: :asciimath)],
          mathml: ["&#x22b9;"],
          latex: [["hermitmatrix", "&#x22b9;"]],
          omml: ["&#x22b9;"],
          html: ["&#x22b9;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\hermitmatrix"
        end

        def to_asciimath(**)
          parsing_wrapper("hermitmatrix", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22b9;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22b9;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22b9;"
        end

        def to_html(**)
          "&#x22b9;"
        end
      end
    end
  end
end
