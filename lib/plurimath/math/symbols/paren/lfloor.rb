module Plurimath
  module Math
    module Symbols
      class Paren
        class Lfloor < Paren
          INPUT = {
            unicodemath: [["&#x230a;", "lfloor"], parsing_wrapper(["|__"], lang: :unicode)],
            asciimath: [["lfloor", "|__", "&#x230a;"]],
            mathml: ["&#x230a;"],
            latex: [["\\lfloor", "&#x230a;"], parsing_wrapper(["|__"], lang: :latex)],
            omml: ["&#x230a;"],
            html: ["&#x230a;"],
          }.freeze

          # output methods
          def to_latex(**)
            "\\lfloor"
          end

          def to_asciimath(**)
            "|__"
          end

          def to_unicodemath(**)
            encoded
          end

          def to_mathml_without_math_tag(_, **)
            ox_element("mo") << encoded
          end

          def to_omml_without_math_tag(_, **)
            "&#x230a;"
          end

          def to_html(**)
            "&#x230a;"
          end

          def open?
            true
          end

          def close?
            false
          end

          def closing
            Rfloor
          end

          private

          def encoded
            Utility.html_entity_to_unicode("&#x230a;")
          end
        end
      end
    end
  end
end
