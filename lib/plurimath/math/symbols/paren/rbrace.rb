module Plurimath
  module Math
    module Symbols
      class Paren
        class Rbrace < Paren
          INPUT = {
            unicodemath: [["&#x7d;"], parsing_wrapper(["rbrace"], lang: :unicode)],
            asciimath: [["&#x7d;"], parsing_wrapper(["rbrace"], lang: :asciimath)],
            mathml: ["&#x7d;"],
            latex: [["\\rbrace", "&#x7d;"]],
            omml: ["&#x7d;"],
            html: ["&#x7d;"],
          }.freeze

          # output methods
          def to_latex(**)
            "\\rbrace"
          end

          def to_asciimath(**)
            parsing_wrapper("rbrace", lang: :asciimath)
          end

          def to_unicodemath(**)
            encoded
          end

          def to_mathml_without_math_tag(_, **)
            ox_element("mi") << encoded
          end

          def to_omml_without_math_tag(_, **)
            "&#x7d;"
          end

          def to_html(**)
            "&#x7d;"
          end

          def open?
            false
          end

          def close?
            true
          end

          def opening
            Lbrace
          end

          private

          def encoded
            Utility.html_entity_to_unicode("&#x7d;")
          end
        end
      end
    end
  end
end
