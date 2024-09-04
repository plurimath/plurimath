module Plurimath
  module Math
    module Symbols
      class Sqsubset < Symbol
        INPUT = {
          unicodemath: [["sqsubset", "&#x228f;"]],
          asciimath: [["&#x228f;"], parsing_wrapper(["sqsubset"], lang: :asciimath)],
          mathml: ["&#x228f;"],
          latex: [["sqsubset", "&#x228f;"]],
          omml: ["&#x228f;"],
          html: ["&#x228f;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\sqsubset"
        end

        def to_asciimath(**)
          parsing_wrapper("sqsubset", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x228f;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x228f;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x228f;"
        end

        def to_html(**)
          "&#x228f;"
        end
      end
    end
  end
end
