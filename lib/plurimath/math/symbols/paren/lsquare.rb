module Plurimath
  module Math
    module Symbols
      class Paren
        class Lsquare < Paren
          INPUT = {
            unicodemath: ["["],
            asciimath: ["["],
            mathml: ["["],
            latex: ["["],
            omml: ["["],
            html: ["["],
          }.freeze

          # output methods
          def to_latex(**)
            paren_value
          end

          def to_asciimath(**)
            paren_value
          end

          def to_unicodemath(**)
            Utility.html_entity_to_unicode(paren_value)
          end

          def to_mathml_without_math_tag(_, **)
            ox_element("mo") << paren_value
          end

          def to_omml_without_math_tag(_, **)
            paren_value
          end

          def to_html(**)
            paren_value
          end

          def open?
            true
          end

          def close?
            false
          end

          def closing
            Rsquare
          end

          def paren_value
            "["
          end

          def to_matrices
            "["
          end
        end
      end
    end
  end
end
