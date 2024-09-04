module Plurimath
  module Math
    module Symbols
      class Gleichstark < Symbol
        INPUT = {
          unicodemath: [["&#x29e6;"], parsing_wrapper(["gleichstark"], lang: :unicode)],
          asciimath: [["&#x29e6;"], parsing_wrapper(["gleichstark"], lang: :asciimath)],
          mathml: ["&#x29e6;"],
          latex: [["gleichstark", "&#x29e6;"]],
          omml: ["&#x29e6;"],
          html: ["&#x29e6;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\gleichstark"
        end

        def to_asciimath(**)
          parsing_wrapper("gleichstark", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x29e6;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x29e6;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x29e6;"
        end

        def to_html(**)
          "&#x29e6;"
        end
      end
    end
  end
end
