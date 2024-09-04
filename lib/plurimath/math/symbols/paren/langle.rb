module Plurimath
  module Math
    module Symbols
      class Paren
        class Langle < Paren
          INPUT = {
            unicodemath: [["&#x2329;", "&#x27e8;", "bra"], parsing_wrapper(["langle", "(:", "<<"], lang: :unicode)],
            asciimath: [["langle", "(:", "<<", "&#x2329;"], parsing_wrapper(["&#x27e8;", "bra"], lang: :asciimath)],
            mathml: ["&#x2329;", "&#x27e8;"],
            latex: [["\\langle", "&#x2329;"], parsing_wrapper(["(:", "<<", "&#x27e8;", "bra"], lang: :latex)],
            omml: ["&#x2329;", "&#x27e8;"],
            html: ["&#x2329;", "&#x27e8;"],
          }.freeze

          # output methods
          def to_latex(**)
            "\\langle"
          end

          def to_asciimath(**)
            "<<"
          end

          def to_unicodemath(**)
            Utility.html_entity_to_unicode("&#x27e8;")
          end

          def to_mathml_without_math_tag(_, **)
            ox_element("mi") << paren_value
          end

          def to_omml_without_math_tag(_, **)
            "&#x27e8;"
          end

          def to_html(**)
            paren_value
          end

          def open?
            true
          end

          def close?
            false
          end

          def closing
            Rangle
          end

          def paren_value
            "&#x2329;"
          end
        end
      end
    end
  end
end
