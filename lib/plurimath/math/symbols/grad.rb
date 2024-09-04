module Plurimath
  module Math
    module Symbols
      class Grad < Symbol
        INPUT = {
          unicodemath: [["nabla", "&#x2207;"], parsing_wrapper(["grad"], lang: :unicode)],
          asciimath: [["nabla", "grad", "&#x2207;"]],
          mathml: ["&#x2207;"],
          latex: [["nabla", "&#x2207;"], parsing_wrapper(["grad"], lang: :latex)],
          omml: ["&#x2207;"],
          html: ["&#x2207;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\nabla"
        end

        def to_asciimath(**)
          "nabla"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2207;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2207;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2207;"
        end

        def to_html(**)
          "&#x2207;"
        end
      end
    end
  end
end
