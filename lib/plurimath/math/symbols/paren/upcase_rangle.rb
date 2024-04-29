module Plurimath
  module Math
    module Symbols
      class Paren
        class UpcaseRangle < Paren
          INPUT = {
            unicodemath: ["&#x27eb;", "Langle"],
            asciimath: [["&#x27eb;"], parsing_wrapper(["Langle"])],
            mathml: ["&#x27eb;"],
            latex: ["&#x27eb;", parsing_wrapper(["Langle"])],
            omml: ["&#x27eb;"],
            html: ["&#x27eb;"],
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
            "&#x27eb;"
          end

          def to_html
            "&#x27eb;"
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
            Utility.html_entity_to_unicode("&#x27eb;")
          end
        end
      end
    end
  end
end
