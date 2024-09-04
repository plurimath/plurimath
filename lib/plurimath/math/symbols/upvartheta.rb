module Plurimath
  module Math
    module Symbols
      class Upvartheta < Symbol
        INPUT = {
          unicodemath: [["&#x3f4;"], parsing_wrapper(["upvarTheta"], lang: :unicode)],
          asciimath: [["&#x3f4;"], parsing_wrapper(["upvarTheta"], lang: :asciimath)],
          mathml: ["&#x3f4;"],
          latex: [["upvarTheta", "&#x3f4;"]],
          omml: ["&#x3f4;"],
          html: ["&#x3f4;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\upvarTheta"
        end

        def to_asciimath(**)
          parsing_wrapper("upvarTheta", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x3f4;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x3f4;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x3f4;"
        end

        def to_html(**)
          "&#x3f4;"
        end
      end
    end
  end
end
