module Plurimath
  module Math
    module Symbols
      class Sprime < Symbol
        INPUT = {
          unicodemath: ["&#x27;"],
          asciimath: ["&#x27;"],
          mathml: ["&#x27;"],
          latex: ["&#x27;"],
          omml: ["&#x27;"],
          html: ["&#x27;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\prime"
        end

        def to_asciimath(**)
          "'"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x27;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mo") << "&#x27;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x27;"
        end

        def to_html(**)
          "&#x27;"
        end
      end
    end
  end
end
