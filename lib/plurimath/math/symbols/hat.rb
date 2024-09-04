module Plurimath
  module Math
    module Symbols
      class Hat < Symbol
        INPUT = {
          unicodemath: [["&#x302;", "^"]],
          asciimath: [["&#x302;", "^"]],
          mathml: ["&#x302;", "^"],
          latex: [["&#x302;", "^"]],
          omml: ["&#x302;", "^"],
          html: ["&#x302;", "^"],
        }.freeze

        # output methods
        def to_latex(**)
          "^"
        end

        def to_asciimath(**)
          "^"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("^")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mo") << "^"
        end

        def to_omml_without_math_tag(_, **)
          "^"
        end

        def to_html(**)
          "^"
        end
      end
    end
  end
end
