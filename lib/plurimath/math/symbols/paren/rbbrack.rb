module Plurimath
  module Math
    module Symbols
      class Paren
        class Rbbrack < Paren
          INPUT = {
            unicodemath: ["&#x27e7;", "rbbrack", "Rbrack"],
            asciimath: [["&#x27e7;"], parsing_wrapper(["rbbrack", "Rbrack"], lang: :asciimath)],
            mathml: ["&#x27e7;"],
            latex: ["&#x27e7;", parsing_wrapper(["rbbrack", "Rbrack"], lang: :latex)],
            omml: ["&#x27e7;"],
            html: ["&#x27e7;"],
          }.freeze

          # output methods
          def to_latex(**)
            "\\rbbrack"
          end

          def to_asciimath(**)
            parsing_wrapper("rbbrack", lang: :asciimath)
          end

          def to_unicodemath(**)
            encoded
          end

          def to_mathml_without_math_tag(_, **)
            ox_element("mi") << encoded
          end

          def to_omml_without_math_tag(_, **)
            "&#x27e7;"
          end

          def to_html(**)
            "&#x27e7;"
          end

          def open?
            true
          end

          def close?
            false
          end

          def closing
            Rbrack
          end

          private

          def encoded
            Utility.html_entity_to_unicode("&#x27e7;")
          end
        end
      end
    end
  end
end
