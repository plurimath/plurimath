module Plurimath
  module Math
    module Symbols
      class Alpha < Symbol
        INPUT = {
          unicodemath: [["alpha", "&#x3b1;"], parsing_wrapper(["upalpha"], lang: :unicode)],
          asciimath: [["alpha", "&#x3b1;"], parsing_wrapper(["upalpha"], lang: :asciimath)],
          mathml: ["&#x3b1;"],
          latex: [["upalpha", "alpha", "&#x3b1;"]],
          omml: ["&#x3b1;"],
          html: ["&#x3b1;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\alpha"
        end

        def to_asciimath(**)
          "alpha"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x3b1;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x3b1;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x3b1;"
        end

        def to_html(**)
          "&#x3b1;"
        end
      end
    end
  end
end
