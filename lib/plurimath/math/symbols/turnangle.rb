module Plurimath
  module Math
    module Symbols
      class Turnangle < Symbol
        INPUT = {
          unicodemath: [["&#x29a2;"], parsing_wrapper(["turnangle"], lang: :unicode)],
          asciimath: [["&#x29a2;"], parsing_wrapper(["turnangle"], lang: :asciimath)],
          mathml: ["&#x29a2;"],
          latex: [["turnangle", "&#x29a2;"]],
          omml: ["&#x29a2;"],
          html: ["&#x29a2;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\turnangle"
        end

        def to_asciimath(**)
          parsing_wrapper("turnangle", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x29a2;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x29a2;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x29a2;"
        end

        def to_html(**)
          "&#x29a2;"
        end
      end
    end
  end
end
