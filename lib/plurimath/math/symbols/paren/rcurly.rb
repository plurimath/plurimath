module Plurimath
  module Math
    module Symbols
      class Paren
        class Rcurly < Paren
          INPUT = {
            unicodemath: ["}"],
            asciimath: ["}"],
            mathml: ["}"],
            latex: ["\\}"],
            omml: ["}"],
            html: ["}"],
          }.freeze

          # output methods
          def to_latex(**)
            "\\#{paren_value}"
          end

          def to_asciimath(**)
            paren_value
          end

          def to_unicodemath(**)
            Utility.html_entity_to_unicode(paren_value)
          end

          def to_mathml_without_math_tag(_, **)
            ox_element("mi") << paren_value
          end

          def to_omml_without_math_tag(_, **)
            paren_value
          end

          def to_html(**)
            paren_value
          end

          def open?
            false
          end

          def close?
            true
          end

          def opening
            Lcurly
          end

          def paren_value
            "}"
          end
        end
      end
    end
  end
end
