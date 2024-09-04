module Plurimath
  module Math
    module Symbols
      class Bbrktbrk < Symbol
        INPUT = {
          unicodemath: [["&#x23b6;"], parsing_wrapper(["bbrktbrk"], lang: :unicode)],
          asciimath: [["&#x23b6;"], parsing_wrapper(["bbrktbrk"], lang: :asciimath)],
          mathml: ["&#x23b6;"],
          latex: [["bbrktbrk", "&#x23b6;"]],
          omml: ["&#x23b6;"],
          html: ["&#x23b6;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\bbrktbrk"
        end

        def to_asciimath(**)
          parsing_wrapper("bbrktbrk", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x23b6;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x23b6;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x23b6;"
        end

        def to_html(**)
          "&#x23b6;"
        end
      end
    end
  end
end
