module Plurimath
  module Math
    module Symbols
      class Rightvectorbar < Symbol
        INPUT = {
          unicodemath: [["&#x2953;"], parsing_wrapper(["rightharpoonupbar", "RightVectorBar"], lang: :unicode)],
          asciimath: [["&#x2953;"], parsing_wrapper(["rightharpoonupbar", "RightVectorBar"], lang: :asciimath)],
          mathml: ["&#x2953;"],
          latex: [["rightharpoonupbar", "RightVectorBar", "&#x2953;"]],
          omml: ["&#x2953;"],
          html: ["&#x2953;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\rightharpoonupbar"
        end

        def to_asciimath(**)
          parsing_wrapper("RightVectorBar", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2953;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2953;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2953;"
        end

        def to_html(**)
          "&#x2953;"
        end
      end
    end
  end
end
