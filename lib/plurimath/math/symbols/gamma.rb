module Plurimath
  module Math
    module Symbols
      class Gamma < Symbol
        INPUT = {
          unicodemath: [["gamma", "&#x3b3;"], parsing_wrapper(["upgamma"], lang: :unicode)],
          asciimath: [["gamma", "&#x3b3;"], parsing_wrapper(["upgamma"], lang: :asciimath)],
          mathml: ["&#x3b3;"],
          latex: [["upgamma", "gamma", "&#x3b3;"]],
          omml: ["&#x3b3;"],
          html: ["&#x3b3;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\gamma"
        end

        def to_asciimath(**)
          "gamma"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x3b3;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x3b3;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x3b3;"
        end

        def to_html(**)
          "&#x3b3;"
        end
      end
    end
  end
end
