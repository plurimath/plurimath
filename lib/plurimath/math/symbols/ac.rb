module Plurimath
  module Math
    module Symbols
      class Ac < Symbol
        INPUT = {
          unicodemath: [["&#x223f;"], parsing_wrapper(["sinewave", "AC"], lang: :unicode)],
          asciimath: [["&#x223f;"], parsing_wrapper(["sinewave", "AC"], lang: :asciimath)],
          mathml: ["&#x223f;"],
          latex: [["sinewave", "AC", "&#x223f;"]],
          omml: ["&#x223f;"],
          html: ["&#x223f;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\sinewave"
        end

        def to_asciimath(**)
          parsing_wrapper("AC", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x223f;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x223f;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x223f;"
        end

        def to_html(**)
          "&#x223f;"
        end
      end
    end
  end
end
