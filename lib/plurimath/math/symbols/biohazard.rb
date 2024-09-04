module Plurimath
  module Math
    module Symbols
      class Biohazard < Symbol
        INPUT = {
          unicodemath: [["&#x2623;"], parsing_wrapper(["biohazard"], lang: :unicode)],
          asciimath: [["&#x2623;"], parsing_wrapper(["biohazard"], lang: :asciimath)],
          mathml: ["&#x2623;"],
          latex: [["biohazard", "&#x2623;"]],
          omml: ["&#x2623;"],
          html: ["&#x2623;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\biohazard"
        end

        def to_asciimath(**)
          parsing_wrapper("biohazard", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2623;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2623;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2623;"
        end

        def to_html(**)
          "&#x2623;"
        end
      end
    end
  end
end
