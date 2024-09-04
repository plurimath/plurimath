module Plurimath
  module Math
    module Symbols
      class Del < Symbol
        INPUT = {
          unicodemath: [["partial", "&#x2202;"], parsing_wrapper(["del", "partialup"], lang: :unicode)],
          asciimath: [["partial", "del", "&#x2202;"], parsing_wrapper(["partialup"], lang: :asciimath)],
          mathml: ["&#x2202;"],
          latex: [["partialup", "partial", "&#x2202;"], parsing_wrapper(["del"], lang: :latex)],
          omml: ["&#x2202;"],
          html: ["&#x2202;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\partial"
        end

        def to_asciimath(**)
          "del"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2202;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mo") << "&#x2202;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2202;"
        end

        def to_html(**)
          "&#x2202;"
        end
      end
    end
  end
end
