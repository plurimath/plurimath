module Plurimath
  module Math
    module Symbols
      class UpcaseGamma < Symbol
        INPUT = {
          unicodemath: [["Gamma", "&#x393;"], parsing_wrapper(["upGamma"], lang: :unicode)],
          asciimath: [["Gamma", "&#x393;"], parsing_wrapper(["upGamma"], lang: :asciimath)],
          mathml: ["&#x393;"],
          latex: [["upGamma", "Gamma", "&#x393;"]],
          omml: ["&#x393;"],
          html: ["&#x393;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\Gamma"
        end

        def to_asciimath(**)
          "Gamma"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x393;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x393;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x393;"
        end

        def to_html(**)
          "&#x393;"
        end
      end
    end
  end
end
