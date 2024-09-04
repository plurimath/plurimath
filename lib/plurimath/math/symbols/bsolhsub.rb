module Plurimath
  module Math
    module Symbols
      class Bsolhsub < Symbol
        INPUT = {
          unicodemath: [["&#x27c8;"], parsing_wrapper(["bsolhsub"], lang: :unicode)],
          asciimath: [["&#x27c8;"], parsing_wrapper(["bsolhsub"], lang: :asciimath)],
          mathml: ["&#x27c8;"],
          latex: [["bsolhsub", "&#x27c8;"]],
          omml: ["&#x27c8;"],
          html: ["&#x27c8;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\bsolhsub"
        end

        def to_asciimath(**)
          parsing_wrapper("bsolhsub", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x27c8;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x27c8;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x27c8;"
        end

        def to_html(**)
          "&#x27c8;"
        end
      end
    end
  end
end
