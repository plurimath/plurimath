module Plurimath
  module Math
    module Symbols
      class Prime < Symbol
        INPUT = {
          unicodemath: ["&#x2032;", "prime", "'"],
          asciimath: ["&#x2032;", "prime", "'"],
          mathml: ["&#x2032;"],
          latex: ["&#x2032;", "prime", "'"],
          omml: ["&#x2032;"],
          html: ["&#x2032;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\prime"
        end

        def to_asciimath(**)
          "prime"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2032;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mo") << "&#x2032;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2032;"
        end

        def to_html(**)
          "&#x2032;"
        end
      end
    end
  end
end
