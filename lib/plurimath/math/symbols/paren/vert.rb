module Plurimath
  module Math
    module Symbols
      class Paren
        class Vert < Paren
          INPUT = {
            unicodemath: [["\\vert", "&#x7c;", "|"], parsing_wrapper(["|"], lang: :unicode)],
            asciimath: [["|", "&#x7c;"], parsing_wrapper(["vert"], lang: :asciimath)],
            mathml: ["&#x7c;", "|"],
            latex: [["\\vert", "|", "&#x7c;"]],
            omml: ["&#x7c;", "|"],
            html: ["&#x7c;", "|"],
          }.freeze

          # output methods
          def to_latex(**)
            "|"
          end

          def to_asciimath(**)
            "|"
          end

          def to_unicodemath(**)
            encoded
          end

          def to_mathml_without_math_tag(_, **)
            ox_element("mo") << encoded
          end

          def to_omml_without_math_tag(_, **)
            encoded
          end

          def to_html(**)
            encoded
          end

          def open?
            true
          end

          def close?
            true
          end

          def opening
            Vert
          end

          def closing
            Vert
          end

          def to_matrices
            "|"
          end

          def paren_value
            "|"
          end

          private

          def encoded
            Utility.html_entity_to_unicode("&#x7c;")
          end
        end
      end
    end
  end
end
