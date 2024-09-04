module Plurimath
  module Math
    module Symbols
      class Lesseqqgtr < Symbol
        INPUT = {
          unicodemath: [["&#x2a8b;"], parsing_wrapper(["lesseqqgtr"], lang: :unicode)],
          asciimath: [["&#x2a8b;"], parsing_wrapper(["lesseqqgtr"], lang: :asciimath)],
          mathml: ["&#x2a8b;"],
          latex: [["lesseqqgtr", "&#x2a8b;"]],
          omml: ["&#x2a8b;"],
          html: ["&#x2a8b;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\lesseqqgtr"
        end

        def to_asciimath(**)
          parsing_wrapper("lesseqqgtr", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a8b;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a8b;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a8b;"
        end

        def to_html(**)
          "&#x2a8b;"
        end
      end
    end
  end
end
