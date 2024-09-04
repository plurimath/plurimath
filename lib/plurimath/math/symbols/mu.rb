module Plurimath
  module Math
    module Symbols
      class Mu < Symbol
        INPUT = {
          unicodemath: [["mu", "&#x3bc;"], parsing_wrapper(["upmu"], lang: :unicode)],
          asciimath: [["mu", "&#x3bc;"], parsing_wrapper(["upmu"], lang: :asciimath)],
          mathml: ["&#x3bc;"],
          latex: [["upmu", "mu", "&#x3bc;"]],
          omml: ["&#x3bc;"],
          html: ["&#x3bc;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\mu"
        end

        def to_asciimath(**)
          "mu"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x3bc;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x3bc;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x3bc;"
        end

        def to_html(**)
          "&#x3bc;"
        end
      end
    end
  end
end
