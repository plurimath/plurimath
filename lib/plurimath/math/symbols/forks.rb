module Plurimath
  module Math
    module Symbols
      class Forks < Symbol
        INPUT = {
          unicodemath: [["&#x2adc;"], parsing_wrapper(["forks"], lang: :unicode)],
          asciimath: [["&#x2adc;"], parsing_wrapper(["forks"], lang: :asciimath)],
          mathml: ["&#x2adc;"],
          latex: [["forks", "&#x2adc;"]],
          omml: ["&#x2adc;"],
          html: ["&#x2adc;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\forks"
        end

        def to_asciimath(**)
          parsing_wrapper("forks", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2adc;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2adc;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2adc;"
        end

        def to_html(**)
          "&#x2adc;"
        end
      end
    end
  end
end
