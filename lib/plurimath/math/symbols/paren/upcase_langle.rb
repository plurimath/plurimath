module Plurimath
  module Math
    module Symbols
      class Paren
        class UpcaseLangle < Paren
          INPUT = {
            unicodemath: ["&#x27ea;", "Langle"],
            asciimath: [["&#x27ea;"], parsing_wrapper(["Langle"])],
            mathml: ["&#x27ea;"],
            latex: ["&#x27ea;", parsing_wrapper(["Langle"])],
            omml: ["&#x27ea;"],
            html: ["&#x27ea;"],
          }.freeze

          # output methods
          def to_latex
            parsing_wrapper("Langle")
          end

          def to_asciimath
            parsing_wrapper("Langle")
          end

          def to_unicodemath
            encoded
          end

          def to_mathml_without_math_tag
            ox_element("mi") << encoded
          end

          def to_omml_without_math_tag(_)
            "&#x27ea;"
          end

          def to_html
            "&#x27ea;"
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
            Utility.html_entity_to_unicode("&#x27ea;")
          end
        end
      end
    end
  end
end
