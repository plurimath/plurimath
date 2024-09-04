module Plurimath
  module Math
    module Symbols
      class Paren
        class Rceil < Paren
          INPUT = {
            unicodemath: [["&#x2309;", "rceil"], parsing_wrapper(["rceiling", "~|"], lang: :unicode)],
            asciimath: [["rceiling", "~|", "&#x2309;"], parsing_wrapper(["rceil"], lang: :asciimath)],
            mathml: ["&#x2309;"],
            latex: [["\\rceil", "&#x2309;"], parsing_wrapper(["rceiling", "~|"], lang: :latex)],
            omml: ["&#x2309;"],
            html: ["&#x2309;"],
          }.freeze

          # output methods
          def to_latex(**)
            "\\rceil"
          end

          def to_asciimath(**)
            "~|"
          end

          def to_unicodemath(**)
            encoded
          end

          def to_mathml_without_math_tag(_, **)
            ox_element("mo") << encoded
          end

          def to_omml_without_math_tag(_, **)
            "&#x2309;"
          end

          def to_html(**)
            "&#x2309;"
          end

          def open?
            false
          end

          def close?
            true
          end

          def opening
            Lceil
          end

          private

          def encoded
            Utility.html_entity_to_unicode("&#x2309;")
          end
        end
      end
    end
  end
end
