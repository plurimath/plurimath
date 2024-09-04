module Plurimath
  module Math
    module Symbols
      class Angle < Symbol
        INPUT = {
          unicodemath: [["rightangle", "angle", "&#x2220;"], parsing_wrapper(["/_"], lang: :unicode)],
          asciimath: [["angle", "/_", "&#x2220;"], parsing_wrapper(["rightangle"], lang: :asciimath)],
          mathml: ["&#x2220;"],
          latex: [["angle", "&#x2220;"], parsing_wrapper(["rightangle", "/_"], lang: :latex)],
          omml: ["&#x2220;"],
          html: ["&#x2220;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\angle"
        end

        def to_asciimath(**)
          "angle"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2220;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2220;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2220;"
        end

        def to_html(**)
          "&#x2220;"
        end
      end
    end
  end
end
