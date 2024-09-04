module Plurimath
  module Math
    module Symbols
      class Cong < Symbol
        INPUT = {
          unicodemath: [["cong", "&#x2245;"], parsing_wrapper(["~="], lang: :unicode)],
          asciimath: [["cong", "~=", "&#x2245;"]],
          mathml: ["&#x2245;"],
          latex: [["cong", "&#x2245;"], parsing_wrapper(["~="], lang: :latex)],
          omml: ["&#x2245;"],
          html: ["&#x2245;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\cong"
        end

        def to_asciimath(**)
          "~="
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2245;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2245;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2245;"
        end

        def to_html(**)
          "&#x2245;"
        end
      end
    end
  end
end
