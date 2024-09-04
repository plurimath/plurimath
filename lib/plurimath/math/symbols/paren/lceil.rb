module Plurimath
  module Math
    module Symbols
      class Paren
        class Lceil < Paren
          INPUT = {
            unicodemath: [["&#x2308;", "lceil"], parsing_wrapper(["lceiling", "|~"], lang: :unicode)],
            asciimath: [["lceiling", "|~", "&#x2308;"], parsing_wrapper(["lceil"], lang: :asciimath)],
            mathml: ["&#x2308;"],
            latex: [["\\lceil", "&#x2308;"], parsing_wrapper(["lceiling", "|~"], lang: :latex)],
            omml: ["&#x2308;"],
            html: ["&#x2308;"],
          }.freeze

          # output methods
          def to_latex(**)
            "\\lceil"
          end

          def to_asciimath(**)
            "|~"
          end

          def to_unicodemath(**)
            encoded
          end

          def to_mathml_without_math_tag(_, **)
            ox_element("mo") << encoded
          end

          def to_omml_without_math_tag(_, **)
            "&#x2308;"
          end

          def to_html(**)
            "&#x2308;"
          end

          def open?
            true
          end

          def close?
            false
          end

          def closing
            Rceil
          end

          private

          def encoded
            Utility.html_entity_to_unicode("&#x2308;")
          end
        end
      end
    end
  end
end
