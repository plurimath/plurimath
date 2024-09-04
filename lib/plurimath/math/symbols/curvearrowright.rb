module Plurimath
  module Math
    module Symbols
      class Curvearrowright < Symbol
        INPUT = {
          unicodemath: [["&#x21b7;"], parsing_wrapper(["curvearrowright"], lang: :unicode)],
          asciimath: [["&#x21b7;"], parsing_wrapper(["curvearrowright"], lang: :asciimath)],
          mathml: ["&#x21b7;"],
          latex: [["curvearrowright", "&#x21b7;"]],
          omml: ["&#x21b7;"],
          html: ["&#x21b7;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\curvearrowright"
        end

        def to_asciimath(**)
          parsing_wrapper("curvearrowright", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x21b7;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x21b7;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x21b7;"
        end

        def to_html(**)
          "&#x21b7;"
        end
      end
    end
  end
end
