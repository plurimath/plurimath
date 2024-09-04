module Plurimath
  module Math
    module Symbols
      class Paren
        class Rangle < Paren
          INPUT = {
            unicodemath: [["&#x232a;", "&#x27e9;", "ket"], parsing_wrapper(["rangle", ":)", ">>", "&#x27e9;"], lang: :unicode)],
            asciimath: [["rangle", ":)", ">>", "&#x232a;", "&#x27e9;"], parsing_wrapper(["&#x27e9;", "ket"], lang: :asciimath)],
            mathml: ["&#x232a;", "&#x27e9;"],
            latex: [["\\rangle", "&#x232a;", "&#x27e9;"], parsing_wrapper([":)", ">>", "&#x27e9;", "ket"], lang: :latex)],
            omml: ["&#x232a;", "&#x27e9;"],
            html: ["&#x232a;", "&#x27e9;"],
          }.freeze

          # output methods
          def to_latex(**)
            "\\rangle"
          end

          def to_asciimath(**)
            ">>"
          end

          def to_unicodemath(**)
            Utility.html_entity_to_unicode("&#x27e9;")
          end

          def to_mathml_without_math_tag(_, **)
            ox_element("mi") << paren_value
          end

          def to_omml_without_math_tag(_, **)
            "&#x27e9;"
          end

          def to_html(**)
            paren_value
          end

          def open?
            false
          end

          def close?
            true
          end

          def opening
            Langle
          end

          def paren_value
            "&#x232a;"
          end
        end
      end
    end
  end
end
