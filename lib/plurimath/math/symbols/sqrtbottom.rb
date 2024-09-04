module Plurimath
  module Math
    module Symbols
      class Sqrtbottom < Symbol
        INPUT = {
          unicodemath: [["&#x23b7;"], parsing_wrapper(["sqrtbottom"], lang: :unicode)],
          asciimath: [["&#x23b7;"], parsing_wrapper(["sqrtbottom"], lang: :asciimath)],
          mathml: ["&#x23b7;"],
          latex: [["sqrtbottom", "&#x23b7;"]],
          omml: ["&#x23b7;"],
          html: ["&#x23b7;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\sqrtbottom"
        end

        def to_asciimath(**)
          parsing_wrapper("sqrtbottom", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x23b7;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x23b7;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x23b7;"
        end

        def to_html(**)
          "&#x23b7;"
        end
      end
    end
  end
end
