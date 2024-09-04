module Plurimath
  module Math
    module Symbols
      class Tau < Symbol
        INPUT = {
          unicodemath: [["tau", "&#x3c4;"], parsing_wrapper(["uptau"], lang: :unicode)],
          asciimath: [["tau", "&#x3c4;"], parsing_wrapper(["uptau"], lang: :asciimath)],
          mathml: ["&#x3c4;"],
          latex: [["uptau", "tau", "&#x3c4;"]],
          omml: ["&#x3c4;"],
          html: ["&#x3c4;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\tau"
        end

        def to_asciimath(**)
          "tau"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x3c4;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x3c4;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x3c4;"
        end

        def to_html(**)
          "&#x3c4;"
        end
      end
    end
  end
end
