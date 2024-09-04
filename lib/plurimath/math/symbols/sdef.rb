module Plurimath
  module Math
    module Symbols
      class Sdef < Symbol
        INPUT = {
          unicodemath: [["&#x2259;"], parsing_wrapper(["corresponds", "wedgeq", "sdef"], lang: :unicode)],
          asciimath: [["&#x2259;"], parsing_wrapper(["corresponds", "wedgeq", "sdef"], lang: :asciimath)],
          mathml: ["&#x2259;"],
          latex: [["corresponds", "wedgeq", "sdef", "&#x2259;"]],
          omml: ["&#x2259;"],
          html: ["&#x2259;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\corresponds"
        end

        def to_asciimath(**)
          parsing_wrapper("sdef", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2259;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2259;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2259;"
        end

        def to_html(**)
          "&#x2259;"
        end
      end
    end
  end
end
