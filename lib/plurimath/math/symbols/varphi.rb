module Plurimath
  module Math
    module Symbols
      class Varphi < Symbol
        INPUT = {
          unicodemath: [["phi", "&#x3d5;"], parsing_wrapper(["upphi"], lang: :unicode)],
          asciimath: [["phi", "&#x3d5;"], parsing_wrapper(["upphi"], lang: :asciimath)],
          mathml: ["&#x3d5;"],
          latex: [["upphi", "phi", "&#x3d5;"]],
          omml: ["&#x3d5;"],
          html: ["&#x3d5;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\upphi"
        end

        def to_asciimath(**)
          "phi"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x3d5;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x3d5;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x3d5;"
        end

        def to_html(**)
          "&#x3d5;"
        end
      end
    end
  end
end
