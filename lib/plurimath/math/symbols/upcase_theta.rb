module Plurimath
  module Math
    module Symbols
      class UpcaseTheta < Symbol
        INPUT = {
          unicodemath: [["Theta", "&#x398;"], parsing_wrapper(["upTheta"], lang: :unicode)],
          asciimath: [["Theta", "&#x398;"], parsing_wrapper(["upTheta"], lang: :asciimath)],
          mathml: ["&#x398;"],
          latex: [["upTheta", "Theta", "&#x398;"]],
          omml: ["&#x398;"],
          html: ["&#x398;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\Theta"
        end

        def to_asciimath(**)
          "Theta"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x398;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mo") << "&#x398;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x398;"
        end

        def to_html(**)
          "&#x398;"
        end
      end
    end
  end
end
