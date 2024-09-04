module Plurimath
  module Math
    module Symbols
      class UpcasePhi < Symbol
        INPUT = {
          unicodemath: [["Phi", "&#x3a6;"], parsing_wrapper(["upPhi"], lang: :unicode)],
          asciimath: [["Phi", "&#x3a6;"], parsing_wrapper(["upPhi"], lang: :asciimath)],
          mathml: ["&#x3a6;"],
          latex: [["upPhi", "Phi", "&#x3a6;"]],
          omml: ["&#x3a6;"],
          html: ["&#x3a6;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\Phi"
        end

        def to_asciimath(**)
          "Phi"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x3a6;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x3a6;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x3a6;"
        end

        def to_html(**)
          "&#x3a6;"
        end
      end
    end
  end
end
