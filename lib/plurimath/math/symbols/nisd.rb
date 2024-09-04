module Plurimath
  module Math
    module Symbols
      class Nisd < Symbol
        INPUT = {
          unicodemath: [["&#x22fa;"], parsing_wrapper(["nisd"], lang: :unicode)],
          asciimath: [["&#x22fa;"], parsing_wrapper(["nisd"], lang: :asciimath)],
          mathml: ["&#x22fa;"],
          latex: [["nisd", "&#x22fa;"]],
          omml: ["&#x22fa;"],
          html: ["&#x22fa;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\nisd"
        end

        def to_asciimath(**)
          parsing_wrapper("nisd", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22fa;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22fa;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22fa;"
        end

        def to_html(**)
          "&#x22fa;"
        end
      end
    end
  end
end
