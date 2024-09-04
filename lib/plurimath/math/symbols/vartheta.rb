module Plurimath
  module Math
    module Symbols
      class Vartheta < Symbol
        INPUT = {
          unicodemath: [["vartheta", "&#x3d1;"], parsing_wrapper(["upvartheta"], lang: :unicode)],
          asciimath: [["vartheta", "&#x3d1;"], parsing_wrapper(["upvartheta"], lang: :asciimath)],
          mathml: ["&#x3d1;"],
          latex: [["upvartheta", "vartheta", "&#x3d1;"]],
          omml: ["&#x3d1;"],
          html: ["&#x3d1;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\upvartheta"
        end

        def to_asciimath(**)
          "vartheta"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x3d1;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x3d1;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x3d1;"
        end

        def to_html(**)
          "&#x3d1;"
        end
      end
    end
  end
end
