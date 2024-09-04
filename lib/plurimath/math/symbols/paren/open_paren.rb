module Plurimath
  module Math
    module Symbols
      class Paren
        class OpenParen < Paren
          INPUT = {
            unicodemath: ["begin", "&#x3016;", parsing_wrapper(["{:"], lang: :unicode)],
            asciimath: ["{:", "&#x3016;", parsing_wrapper(["begin"], lang: :asciimath)],
            mathml: ["&#x3016;"],
            latex: ["&#x3016;", parsing_wrapper(["begin", "{:"], lang: :latex)],
            omml: ["&#x3016;"],
            html: ["&#x3016;"],
          }.freeze

          # output methods
          def to_latex(**)
            "\\left."
          end

          def to_asciimath(**)
            "{:"
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
            "&#x3016;"
          end
        end
      end
    end
  end
end
