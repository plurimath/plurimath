module Plurimath
  module Math
    module Symbols
      class Circledgtr < Symbol
        INPUT = {
          unicodemath: [["&#x29c1;"], parsing_wrapper(["ogreaterthan", "circledgtr"], lang: :unicode)],
          asciimath: [["&#x29c1;"], parsing_wrapper(["ogreaterthan", "circledgtr"], lang: :asciimath)],
          mathml: ["&#x29c1;"],
          latex: [["ogreaterthan", "circledgtr", "&#x29c1;"]],
          omml: ["&#x29c1;"],
          html: ["&#x29c1;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\ogreaterthan"
        end

        def to_asciimath(**)
          parsing_wrapper("circledgtr", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x29c1;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x29c1;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x29c1;"
        end

        def to_html(**)
          "&#x29c1;"
        end
      end
    end
  end
end
