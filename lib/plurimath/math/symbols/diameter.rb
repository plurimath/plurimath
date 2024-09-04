module Plurimath
  module Math
    module Symbols
      class Diameter < Symbol
        INPUT = {
          unicodemath: [["&#x2300;"], parsing_wrapper(["diameter"], lang: :unicode)],
          asciimath: [["&#x2300;"], parsing_wrapper(["diameter"], lang: :asciimath)],
          mathml: ["&#x2300;"],
          latex: [["diameter", "&#x2300;"]],
          omml: ["&#x2300;"],
          html: ["&#x2300;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\diameter"
        end

        def to_asciimath(**)
          parsing_wrapper("diameter", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2300;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2300;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2300;"
        end

        def to_html(**)
          "&#x2300;"
        end
      end
    end
  end
end
