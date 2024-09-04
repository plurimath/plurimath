module Plurimath
  module Math
    module Symbols
      class Paren
        class Lbrack < Paren
          INPUT = {
            unicodemath: ["&#x5b;", "lbrack"],
            asciimath: [["&#x5b;"], parsing_wrapper(["lbrack"], lang: :asciimath)],
            mathml: ["&#x5b;"],
            latex: ["\\lbrack", "&#x5b;"],
            omml: ["&#x5b;"],
            html: ["&#x5b;"],
          }.freeze

          # output methods
          def to_latex(**)
            "\\lbrack"
          end

          def to_asciimath(**)
            parsing_wrapper("lbrack", lang: :asciimath)
          end

          def to_unicodemath(**)
            encoded
          end

          def to_mathml_without_math_tag(_, **)
            ox_element("mi") << encoded
          end

          def to_omml_without_math_tag(_, **)
            "&#x5b;"
          end

          def to_html(**)
            "&#x5b;"
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
            Utility.html_entity_to_unicode("&#x5b;")
          end
        end
      end
    end
  end
end
