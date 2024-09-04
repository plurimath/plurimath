module Plurimath
  module Math
    module Symbols
      class Lcurvyangle < Symbol
        INPUT = {
          unicodemath: [["&#x29fc;"], parsing_wrapper(["lcurvyangle"], lang: :unicode)],
          asciimath: [["&#x29fc;"], parsing_wrapper(["lcurvyangle"], lang: :asciimath)],
          mathml: ["&#x29fc;"],
          latex: [["lcurvyangle", "&#x29fc;"]],
          omml: ["&#x29fc;"],
          html: ["&#x29fc;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\lcurvyangle"
        end

        def to_asciimath(**)
          parsing_wrapper("lcurvyangle", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x29fc;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x29fc;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x29fc;"
        end

        def to_html(**)
          "&#x29fc;"
        end
      end
    end
  end
end
