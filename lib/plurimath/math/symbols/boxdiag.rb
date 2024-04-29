module Plurimath
  module Math
    module Symbols
      class Boxdiag < Symbol
        INPUT = {
          unicodemath: [["&#x29c4;"], parsing_wrapper(["boxslash", "boxdiag"])],
          asciimath: [["&#x29c4;"], parsing_wrapper(["boxslash", "boxdiag"])],
          mathml: ["&#x29c4;"],
          latex: [["boxslash", "boxdiag", "&#x29c4;"]],
          omml: ["&#x29c4;"],
          html: ["&#x29c4;"],
        }.freeze

        # output methods
        def to_latex
          "\\boxslash"
        end

        def to_asciimath
          parsing_wrapper("boxdiag")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x29c4;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x29c4;"
        end

        def to_omml_without_math_tag(_)
          "&#x29c4;"
        end

        def to_html
          "&#x29c4;"
        end
      end
    end
  end
end
