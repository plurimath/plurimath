module Plurimath
  module Math
    module Symbols
      class ThreePerEmSpace < Symbol
        INPUT = {
          unicodemath: [["&#x2004;"], parsing_wrapper(["\\;"], lang: :unicode)],
          asciimath: [[";", "&#x2004;"], parsing_wrapper(["\\;"], lang: :asciimath)],
          mathml: ["&#x2004;"],
          latex: [["\\;", "&#x2004;"]],
          omml: ["&#x2004;"],
          html: ["&#x2004;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\;"
        end

        def to_asciimath(**)
          parsing_wrapper("\\;", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2004;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mo") << "&#x2004;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2004;"
        end

        def to_html(**)
          "&#x2004;"
        end
      end
    end
  end
end
