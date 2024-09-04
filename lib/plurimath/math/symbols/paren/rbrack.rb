module Plurimath
  module Math
    module Symbols
      class Paren
        class Rbrack < Paren
          INPUT = {
            unicodemath: [["&#x5d;"], parsing_wrapper(["rbrack"], lang: :unicode)],
            asciimath: [["&#x5d;"], parsing_wrapper(["rbrack"], lang: :asciimath)],
            mathml: ["&#x5d;"],
            latex: [["\\rbrack", "&#x5d;"]],
            omml: ["&#x5d;"],
            html: ["&#x5d;"],
          }.freeze

          # output methods
          def to_latex(**)
            "\\rbrack"
          end

          def to_asciimath(**)
            parsing_wrapper("rbrack", lang: :asciimath)
          end

          def to_unicodemath(**)
            encoded
          end

          def to_mathml_without_math_tag(_, **)
            ox_element("mi") << encoded
          end

          def to_omml_without_math_tag(_, **)
            "&#x5d;"
          end

          def to_html(**)
            "&#x5d;"
          end

          def open?
            false
          end

          def close?
            true
          end

          def opening
            Lbrack
          end

          private

          def encoded
            Utility.html_entity_to_unicode("&#x5d;")
          end
        end
      end
    end
  end
end
