module Plurimath
  module Math
    module Symbols
      class Paren
        class Lbbrack < Paren
          INPUT = {
            unicodemath: ["&#x27e6;", "lbbrack", "Lbrack"],
            asciimath: [["&#x27e6;"], parsing_wrapper(["lbbrack", "Lbrack"], lang: :asciimath)],
            mathml: ["&#x27e6;"],
            latex: ["&#x27e6;", parsing_wrapper(["lbbrack", "Lbrack"], lang: :latex)],
            omml: ["&#x27e6;"],
            html: ["&#x27e6;"],
          }.freeze

          # output methods
          def to_latex(**)
            "\\lbbrack"
          end

          def to_asciimath(**)
            parsing_wrapper("lbbrack", lang: :asciimath)
          end

          def to_unicodemath(**)
            encoded
          end

          def to_mathml_without_math_tag(_, **)
            ox_element("mi") << encoded
          end

          def to_omml_without_math_tag(_, **)
            "&#x27e6;"
          end

          def to_html(**)
            "&#x27e6;"
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
            Utility.html_entity_to_unicode("&#x27e6;")
          end
        end
      end
    end
  end
end
