module Plurimath
  module Math
    module Symbols
      class Rho < Symbol
        INPUT = {
          unicodemath: [["rho", "&#x3c1;"], parsing_wrapper(["uprho"], lang: :unicode)],
          asciimath: [["rho", "&#x3c1;"], parsing_wrapper(["uprho"], lang: :asciimath)],
          mathml: ["&#x3c1;"],
          latex: [["uprho", "rho", "&#x3c1;"]],
          omml: ["&#x3c1;"],
          html: ["&#x3c1;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\rho"
        end

        def to_asciimath(**)
          "rho"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x3c1;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x3c1;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x3c1;"
        end

        def to_html(**)
          "&#x3c1;"
        end
      end
    end
  end
end
