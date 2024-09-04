module Plurimath
  module Math
    module Symbols
      class UpcaseLambda < Symbol
        INPUT = {
          unicodemath: [["Lambda", "&#x39b;"], parsing_wrapper(["upLambda"], lang: :unicode)],
          asciimath: [["Lambda", "&#x39b;"], parsing_wrapper(["upLambda"], lang: :asciimath)],
          mathml: ["&#x39b;"],
          latex: [["upLambda", "Lambda", "&#x39b;"]],
          omml: ["&#x39b;"],
          html: ["&#x39b;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\Lambda"
        end

        def to_asciimath(**)
          "Lambda"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x39b;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x39b;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x39b;"
        end

        def to_html(**)
          "&#x39b;"
        end
      end
    end
  end
end
