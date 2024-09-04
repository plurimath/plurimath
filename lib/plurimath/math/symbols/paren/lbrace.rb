module Plurimath
  module Math
    module Symbols
      class Paren
        class Lbrace < Paren
          INPUT = {
            unicodemath: [["&#x7b;", "lbrace"]],
            asciimath: [["&#x7b;"], parsing_wrapper(["lbrace"], lang: :asciimath)],
            mathml: ["&#x7b;"],
            latex: [["\\lbrace", "&#x7b;"]],
            omml: ["&#x7b;"],
            html: ["&#x7b;"],
          }.freeze

          # output methods
          def to_latex(**)
            "\\lbrace"
          end

          def to_asciimath(**)
            parsing_wrapper("lbrace", lang: :asciimath)
          end

          def to_unicodemath(**)
            encoded
          end

          def to_mathml_without_math_tag(_, **)
            ox_element("mi") << encoded
          end

          def to_omml_without_math_tag(_, **)
            "&#x7b;"
          end

          def to_html(**)
            "&#x7b;"
          end

          def open?
            true
          end

          def close?
            false
          end

          def closing
            Rbrace
          end

          private

          def encoded
            Utility.html_entity_to_unicode("&#x7b;")
          end
        end
      end
    end
  end
end
