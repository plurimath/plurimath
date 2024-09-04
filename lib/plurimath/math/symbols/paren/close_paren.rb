module Plurimath
  module Math
    module Symbols
      class Paren
        class CloseParen < Paren
          INPUT = {
            unicodemath: ["end", "&#x3017;", parsing_wrapper([":}"], lang: :unicode)],
            asciimath: [":}", "&#x3017;", parsing_wrapper(["end"], lang: :asciimath)],
            mathml: ["&#x3017;"],
            latex: ["&#x3017;", parsing_wrapper(["end", ":}"], lang: :latex)],
            omml: ["&#x3017;"],
            html: ["&#x3017;"],
          }.freeze

          # output methods
          def to_latex(**)
            "\\right."
          end

          def to_asciimath(**)
            ":}"
          end

          def to_unicodemath(**)
            Utility.html_entity_to_unicode(paren_value)
          end

          def to_mathml_without_math_tag(_, **)
            ox_element("mi") << paren_value
          end

          def to_omml_without_math_tag(_, **)
            paren_value
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
            "&#x3017;"
          end
        end
      end
    end
  end
end
