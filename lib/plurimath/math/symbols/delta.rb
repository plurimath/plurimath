module Plurimath
  module Math
    module Symbols
      class Delta < Symbol
        INPUT = {
          unicodemath: [["delta", "&#x3b4;"], parsing_wrapper(["updelta"], lang: :unicode)],
          asciimath: [["delta", "&#x3b4;"], parsing_wrapper(["updelta"], lang: :asciimath)],
          mathml: ["&#x3b4;"],
          latex: [["updelta", "delta", "&#x3b4;"]],
          omml: ["&#x3b4;"],
          html: ["&#x3b4;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\delta"
        end

        def to_asciimath(**)
          "delta"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x3b4;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x3b4;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x3b4;"
        end

        def to_html(**)
          "&#x3b4;"
        end
      end
    end
  end
end
