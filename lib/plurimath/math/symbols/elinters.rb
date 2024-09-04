module Plurimath
  module Math
    module Symbols
      class Elinters < Symbol
        INPUT = {
          unicodemath: [["&#x23e7;"], parsing_wrapper(["elinters"], lang: :unicode)],
          asciimath: [["&#x23e7;"], parsing_wrapper(["elinters"], lang: :asciimath)],
          mathml: ["&#x23e7;"],
          latex: [["elinters", "&#x23e7;"]],
          omml: ["&#x23e7;"],
          html: ["&#x23e7;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\elinters"
        end

        def to_asciimath(**)
          parsing_wrapper("elinters", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x23e7;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x23e7;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x23e7;"
        end

        def to_html(**)
          "&#x23e7;"
        end
      end
    end
  end
end
