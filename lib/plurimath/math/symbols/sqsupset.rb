module Plurimath
  module Math
    module Symbols
      class Sqsupset < Symbol
        INPUT = {
          unicodemath: [["sqsupset", "&#x2290;"]],
          asciimath: [["&#x2290;"], parsing_wrapper(["sqsupset"], lang: :asciimath)],
          mathml: ["&#x2290;"],
          latex: [["sqsupset", "&#x2290;"]],
          omml: ["&#x2290;"],
          html: ["&#x2290;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\sqsupset"
        end

        def to_asciimath(**)
          parsing_wrapper("sqsupset", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2290;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2290;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2290;"
        end

        def to_html(**)
          "&#x2290;"
        end
      end
    end
  end
end
