module Plurimath
  module Math
    module Symbols
      class Apprge < Symbol
        INPUT = {
          unicodemath: [["gtrsim", "&#x2273;"], parsing_wrapper(["apprge"], lang: :unicode)],
          asciimath: [["&#x2273;"], parsing_wrapper(["gtrsim", "apprge"], lang: :asciimath)],
          mathml: ["&#x2273;"],
          latex: [["gtrsim", "apprge", "&#x2273;"]],
          omml: ["&#x2273;"],
          html: ["&#x2273;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\gtrsim"
        end

        def to_asciimath(**)
          parsing_wrapper("apprge", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2273;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2273;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2273;"
        end

        def to_html(**)
          "&#x2273;"
        end
      end
    end
  end
end
