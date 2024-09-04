module Plurimath
  module Math
    module Symbols
      class Succ < Symbol
        INPUT = {
          unicodemath: [["succ", "&#x227b;"], parsing_wrapper([">-"], lang: :unicode)],
          asciimath: [["succ", ">-", "&#x227b;"]],
          mathml: ["&#x227b;"],
          latex: [["succ", "&#x227b;"], parsing_wrapper([">-"], lang: :latex)],
          omml: ["&#x227b;"],
          html: ["&#x227b;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\succ"
        end

        def to_asciimath(**)
          "succ"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x227b;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x227b;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x227b;"
        end

        def to_html(**)
          "&#x227b;"
        end
      end
    end
  end
end
