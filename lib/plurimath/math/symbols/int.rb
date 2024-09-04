module Plurimath
  module Math
    module Symbols
      class Int < Symbol
        INPUT = {
          unicodemath: [["&#x222b;"]],
          asciimath: [["&#x222b;"]],
          mathml: ["&#x222b;"],
          latex: [["&#x222b;"]],
          omml: ["&#x222b;"],
          html: ["&#x222b;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\int"
        end

        def to_asciimath(**)
          "int"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x222b;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mo") << "&#x222b;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x222b;"
        end

        def to_html(**)
          "&#x222b;"
        end
      end
    end
  end
end
