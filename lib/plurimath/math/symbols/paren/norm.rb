module Plurimath
  module Math
    module Symbols
      class Paren
        class Norm < Paren
          INPUT = {
            unicodemath: [["\\Vert", "Vert", "norm", "&#x2016;"]],
            asciimath: [["&#x2016;"], parsing_wrapper(["Vert", "norm"], lang: :asciimath)],
            mathml: ["&#x2016;"],
            latex: [["\\Vert", "&#x2016;"], parsing_wrapper(["norm"], lang: :latex)],
            omml: ["&#x2016;"],
            html: ["&#x2016;"],
          }.freeze

          # output methods
          def to_latex(**)
            "\\Vert"
          end

          def to_asciimath(**)
            "norm"
          end

          def to_unicodemath(**)
            encoded
          end

          def to_mathml_without_math_tag(_, **)
            ox_element("mi") << encoded
          end

          def to_omml_without_math_tag(_, **)
            "&#x2016;"
          end

          def to_html(**)
            "&#x2016;"
          end

          def open?
            true
          end

          def close?
            false
          end

          def closing
            Norm
          end

          def opening
            Norm
          end

          def to_matrices
            "\\Vert"
          end

          def paren_value
            encoded
          end

          private

          def encoded
            Utility.html_entity_to_unicode("&#x2016;")
          end
        end
      end
    end
  end
end
