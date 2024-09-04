module Plurimath
  module Math
    module Symbols
      class Deltaeq < Symbol
        INPUT = {
          unicodemath: [["Deltaeq", "&#x225c;"], parsing_wrapper(["triangleq", "varsdef"], lang: :unicode)],
          asciimath: [["&#x225c;"], parsing_wrapper(["Deltaeq", "triangleq", "varsdef"], lang: :asciimath)],
          mathml: ["&#x225c;"],
          latex: [["triangleq", "varsdef", "&#x225c;"], parsing_wrapper(["Deltaeq"], lang: :latex)],
          omml: ["&#x225c;"],
          html: ["&#x225c;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\Deltaeq"
        end

        def to_asciimath(**)
          "Deltaeq"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x225c;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x225c;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x225c;"
        end

        def to_html(**)
          "&#x225c;"
        end
      end
    end
  end
end
