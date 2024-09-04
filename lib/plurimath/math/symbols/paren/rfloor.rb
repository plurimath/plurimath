module Plurimath
  module Math
    module Symbols
      class Paren
        class Rfloor < Paren
          INPUT = {
            unicodemath: [["&#x230b;", "rfloor"], parsing_wrapper(["__|"], lang: :unicode)],
            asciimath: [["rfloor", "__|", "&#x230b;"]],
            mathml: ["&#x230b;"],
            latex: [["\\rfloor", "&#x230b;"], parsing_wrapper(["__|"], lang: :latex)],
            omml: ["&#x230b;"],
            html: ["&#x230b;"],
          }.freeze

          # output methods
          def to_latex(**)
            "\\rfloor"
          end

          def to_asciimath(**)
            "__|"
          end

          def to_unicodemath(**)
            encoded
          end

          def to_mathml_without_math_tag(_, **)
            ox_element("mo") << encoded
          end

          def to_omml_without_math_tag(_, **)
            "&#x230b;"
          end

          def to_html(**)
            "&#x230b;"
          end

          def open?
            false
          end

          def close?
            true
          end

          def opening
            Lfloor
          end

          private

          def encoded
            Utility.html_entity_to_unicode("&#x230b;")
          end
        end
      end
    end
  end
end
