module Plurimath
  module Math
    module Symbols
      class Sup < Symbol
        INPUT = {
          unicodemath: [["supset", "&#x2283;"], parsing_wrapper(["sup"], lang: :unicode)],
          asciimath: [["supset", "sup", "&#x2283;"]],
          mathml: ["&#x2283;"],
          latex: [["supset", "&#x2283;"], parsing_wrapper(["sup"], lang: :latex)],
          omml: ["&#x2283;"],
          html: ["&#x2283;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\supset"
        end

        def to_asciimath(**)
          "supset"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2283;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2283;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2283;"
        end

        def to_html(**)
          "&#x2283;"
        end
      end
    end
  end
end
